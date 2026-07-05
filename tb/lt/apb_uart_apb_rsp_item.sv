// This file defines the apb_uart_apb_rsp_item class, which extends the base APB sequence item.
// It is used to represent the response transaction from the APB UART interface, 
// including the slave error (slverr) status and data fields.

`ifndef __GUARD_APB_UART_APB_RSP_ITEM_SV__
`define __GUARD_APB_UART_APB_RSP_ITEM_SV__ 0

`include "package/uart_pkg.sv"
`include "lt/apb_uart_apb_seq_item.sv"

class apb_uart_apb_rsp_item extends apb_uart_apb_seq_item;

  bit slverr;

  // Converts the transaction fields into a formatted string for logging purposes.
  virtual function automatic string to_string();
    if (write) begin
      return $sformatf("%s, slverr=0x%01h", super.to_string(), slverr);
    end else begin
      return $sformatf("%s, data=0x%08h, slverr=0x%01h", super.to_string(), data, slverr);
    end
  endfunction

  // Displays the transaction details to the standard output.
  virtual function automatic void display();
    $display("APB UART APB Response Item: %s", to_string());
  endfunction

endclass

`endif

