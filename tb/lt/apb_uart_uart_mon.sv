/*
 * File: apb_uart_uart_mon.sv
 * Description: This file defines the apb_uart_uart_mon class, which acts as a 
 * monitor for the UART interface. It captures transactions from the physical 
 * interface and pushes them into a mailbox for further analysis or verification.
 */

`ifndef __GUARD_APB_UART_UART_MON_SV__
`define __GUARD_APB_UART_UART_MON_SV__ 0

`include "lt/apb_uart_uart_rsp_item.sv"

class apb_uart_uart_mon;

  virtual uart_if intf;

  mailbox #(apb_uart_uart_rsp_item) mbx;

  // Connects the monitor to the physical UART interface
  virtual function void connect_intf(virtual uart_if intf);
    this.intf = intf;
  endfunction

  // Connects the monitor to the mailbox containing response items
  virtual function void connect_mbx(mailbox #(apb_uart_uart_rsp_item) mbx);
    this.mbx = mbx;
  endfunction

  // Main execution task that continuously processes items from the mailbox
  virtual task run();
    fork
      forever begin
        apb_uart_uart_rsp_item item;
        item = new();
        intf.recv_rx(item.data, item.parity_bit);
        item.dut_2_tb        = 1;
        item.baud_rate       = intf.BAUD_RATE;
        item.parity_enable   = intf.PARITY_ENABLE;
        item.parity_type     = intf.PARITY_TYPE;
        item.second_stop_bit = intf.SECOND_STOP_BIT;
        item.data_bits       = intf.DATA_BITS;
        mbx.put(item);
      end
      forever begin
        apb_uart_uart_rsp_item item;
        item = new();
        intf.recv_tx(item.data, item.parity_bit);
        item.dut_2_tb        = 0;
        item.baud_rate       = intf.BAUD_RATE;
        item.parity_enable   = intf.PARITY_ENABLE;
        item.parity_type     = intf.PARITY_TYPE;
        item.second_stop_bit = intf.SECOND_STOP_BIT;
        item.data_bits       = intf.DATA_BITS;
        mbx.put(item);
      end
    join_none
  endtask

endclass

`endif

