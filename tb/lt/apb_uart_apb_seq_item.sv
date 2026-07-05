// This file defines the apb_uart_apb_seq_item class, which represents a single APB transaction 
// for the UART peripheral. It includes randomization constraints for valid addresses, 
// read/write permissions, and data ranges, as well as helper functions for string 
// representation and display.

`ifndef __GUARD_APB_UART_APB_SEQ_ITEM_SV__
`define __GUARD_APB_UART_APB_SEQ_ITEM_SV__ 0

`include "package/uart_pkg.sv"

import uart_pkg::ADDR_WIDTH;
import uart_pkg::DATA_WIDTH;

import uart_pkg::UART_CTRL_OFFSET;
import uart_pkg::UART_CFG_OFFSET;
import uart_pkg::UART_STAT_OFFSET;
import uart_pkg::UART_TX_DATA_OFFSET;
import uart_pkg::UART_RX_DATA_OFFSET;

class apb_uart_apb_seq_item;


  static bit allow_invalid_addr = 0;
  static bit allow_rw_violation = 0;

  rand bit                  write;
  rand bit [ADDR_WIDTH-1:0] addr;
  rand bit [DATA_WIDTH-1:0] data;

  constraint addr_c {
    if (!allow_invalid_addr) {
      addr inside {UART_CTRL_OFFSET, UART_CFG_OFFSET, UART_STAT_OFFSET, UART_TX_DATA_OFFSET, UART_RX_DATA_OFFSET};
    }
    addr % 4 == 0;
    if (!allow_rw_violation) {
      if (write) {
        addr inside {UART_CTRL_OFFSET, UART_CFG_OFFSET, UART_TX_DATA_OFFSET};
      } else {
        addr inside {UART_CTRL_OFFSET, UART_CFG_OFFSET, UART_STAT_OFFSET, UART_RX_DATA_OFFSET};
      }
    }
  }

  constraint data_c {
    if (write) {
       if (addr == UART_CTRL_OFFSET)    data < (2 ** 3);
       if (addr == UART_CFG_OFFSET)     data < (2 ** 15);
       if (addr == UART_TX_DATA_OFFSET) data < (2 ** 8);
    }
  }

  virtual function automatic string to_string();
    if (write) begin
      return $sformatf("WRITE addr=0x%02h, data=0x%08h", addr, data);
    end else begin
      return $sformatf("READ  addr=0x%02h", addr);
    end
  endfunction

  virtual function automatic void display();
    $display("APB UART APB Sequence Item: %s", to_string());
  endfunction

endclass

`endif
