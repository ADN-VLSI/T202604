// This file defines the apb_uart_uart_rsp_item class, which extends the base sequence item
// to include response-specific fields such as the slave error (slverr) signal.
// It provides methods to convert transaction details to strings and display them for verification.

`ifndef __GUARD_APB_UART_UART_RSP_ITEM_SV__
`define __GUARD_APB_UART_UART_RSP_ITEM_SV__ 0

`include "lt/apb_uart_uart_seq_item.sv"

class apb_uart_uart_rsp_item extends apb_uart_uart_seq_item;

  bit dut_2_tb   = 0;
  bit parity_bit = 0;

  // Displays the transaction details to the standard output.
  virtual function automatic void display();
    $display("APB UART UART Response Item: %s, parity_bit: %0b, direction: %s",
              to_string(),parity_bit, dut_2_tb ? "DUT->TB" : "TB->DUT");
  endfunction

endclass

`endif

