// This file defines the apb_uart_apb_dvr class, which acts as a driver for the APB UART interface.
// It is responsible for driving APB bus transactions by consuming sequence items from a mailbox
// and executing the corresponding read or write operations on the virtual APB interface.

`ifndef __GUARD_APB_UART_APB_DVR_SV__
`define __GUARD_APB_UART_APB_DVR_SV__ 0

`include "lt/apb_uart_apb_seq_item.sv"

class apb_uart_apb_dvr;

  virtual apb_if intf;

  mailbox #(apb_uart_apb_seq_item) mbx;

  // Connects the driver to the physical APB interface
  virtual function void connect_intf(virtual apb_if intf);
    this.intf = intf;
  endfunction

  // Connects the driver to the mailbox containing sequence items
  virtual function void connect_mbx(mailbox #(apb_uart_apb_seq_item) mbx);
    this.mbx = mbx;
  endfunction

  // Main execution task that continuously processes items from the mailbox
  virtual task run();
    fork
      forever begin
        apb_uart_apb_seq_item item;
        mbx.peek(item);
        if (item.write) intf.write(item.addr, item.data);
        else            intf.read(item.addr, item.data);
          mbx.get(item);
        end
    join_none
  endtask

endclass

`endif

