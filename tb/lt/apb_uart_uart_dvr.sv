// This file defines the apb_uart_uart_dvr class, which acts as a driver for the UART interface.
// It is responsible for receiving sequence items from a mailbox and executing the corresponding
// read or write operations on the physical UART interface.

`ifndef __GUARD_APB_UART_UART_DVR_SV__
`define __GUARD_APB_UART_UART_DVR_SV__ 0

`include "lt/apb_uart_uart_seq_item.sv"

class apb_uart_uart_dvr;

  virtual uart_if intf;

  mailbox #(apb_uart_uart_seq_item) mbx;

  // Connects the driver to the physical UART interface
  virtual function void connect_intf(virtual uart_if intf);
    this.intf = intf;
  endfunction

  // Connects the driver to the mailbox containing sequence items
  virtual function void connect_mbx(mailbox #(apb_uart_uart_seq_item) mbx);
    this.mbx = mbx;
  endfunction

  // Main execution task that continuously processes items from the mailbox
  virtual task run();
    fork
      forever begin
        apb_uart_uart_seq_item item;
        mbx.peek(item);
        intf.send_tx(item.data);
        mbx.get(item);
      end
    join_none
  endtask

endclass

`endif

