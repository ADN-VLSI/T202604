`ifndef __GUARD_APB_UART_SCBD__
`define __GUARD_APB_UART_SCBD__ 0

`include "lt/uart_cfg.sv"

`include "lt/apb_uart_apb_rsp_item.sv"
`include "lt/apb_uart_uart_rsp_item.sv"

import uart_pkg::UART_CTRL_OFFSET;
import uart_pkg::UART_CFG_OFFSET;
import uart_pkg::UART_STAT_OFFSET;
import uart_pkg::UART_TX_DATA_OFFSET;
import uart_pkg::UART_RX_DATA_OFFSET;

class apb_uart_scbd;

  mailbox #(uart_cfg) uart_cfg_mbx;

  mailbox #(apb_uart_apb_rsp_item) apb_mbx;
  mailbox #(apb_uart_uart_rsp_item) uart_mbx;

  bit [7:0] tx_data[$];
  bit [7:0] rx_data[$];

  int pass = 0;
  int fail = 0;

  // Connects the monitor to the mailbox containing APB response items
  virtual function void connect_apb_mbx(mailbox#(apb_uart_apb_rsp_item) mbx);
    this.apb_mbx = mbx;
  endfunction

  // Connects the monitor to the mailbox containing UART response items
  virtual function void connect_uart_mbx(mailbox#(apb_uart_uart_rsp_item) mbx);
    this.uart_mbx = mbx;
  endfunction

  // Connects the monitor to the mailbox containing UART configuration items
  virtual function void connect_uart_cfg_mbx(mailbox#(uart_cfg) mbx);
    this.uart_cfg_mbx = mbx;
  endfunction

  virtual task run();
    fork

      // APB response item processing
      forever begin
        apb_uart_apb_rsp_item apb_item;
        apb_mbx.get(apb_item);
        $display("\n\n\nAPB Response Item: \n%s\n\n\n", apb_item.to_string()); // TODO REMOVE

        // UPDATE UART CONFIGURATION BASED ON APB RESPONSE
        if ((apb_item.slverr == 0) && (apb_item.addr == UART_CFG_OFFSET)) begin
          uart_cfg cfg;
          cfg = new();
          cfg.BAUD_RATE = apb_item.data[11:0];
          cfg.BAUD_RATE = 100_000_000 / cfg.BAUD_RATE; 
          cfg.PARITY_ENABLE = apb_item.data[12];
          cfg.PARITY_TYPE = apb_item.data[13];
          cfg.SECOND_STOP_BIT = apb_item.data[14];
          cfg.DATA_BITS = 8;
          uart_cfg_mbx.put(cfg);
        end

        // STORE TX DATA
        else if ((apb_item.slverr == 0) && (apb_item.write == 1) && (apb_item.addr == UART_TX_DATA_OFFSET)) begin
          tx_data.push_back(apb_item.data[7:0]);
        end

      end

      // UART response item processing
      forever begin
        apb_uart_uart_rsp_item item;
        bit OK;
        uart_mbx.get(item);
        $display("\n\n\nUART Response Item: \n%s\n\n\n", item.to_string()); // TODO REMOVE

        // PROCESS DUT TO TB TRANSACTIONS
        if (item.dut_2_tb == 1) begin
          OK = 1;
          if (item.data !== tx_data.pop_front()) begin
            $display("ERROR: UART Response Item data does not match expected tx_data. Received: %0h", item.data);
            OK = 0;
          end
          if (item.parity_enable) begin
            if (item.parity_bit !== ((~item.parity_type)^(^item.data))) begin
              $display("ERROR: UART Response Item parity does not match expected parity. Data: %0h, Parity: %0b, Parity Type: %s",
                       item.data, item.parity_bit, item.parity_type ? "Odd " : "Even");
              OK = 0;
            end
          end
          if (OK) begin
            pass++;
            $display("UART Response Item matches expected values. Total Pass: %0d", pass);
          end else begin
            fail++;
            $display("UART Response Item does not match expected values. Total Fail: %0d", fail);
          end
        end
      end
      
    join_none
  endtask

  virtual function void report();
    $display("Total Pass: %0d, Total Fail: %0d", pass, fail);
    if (fail) $display("TEST FAILED");
    else      $display("TEST PASSED");
  endfunction

endclass

`endif
