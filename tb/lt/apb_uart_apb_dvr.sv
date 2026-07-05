// @foez-bhai, please add comments describing the purpose of this file and its functions

`ifndef __GUARD_APB_UART_APB_DVR_SV__
`define __GUARD_APB_UART_APB_DVR_SV__ 0

`include "lt/apb_uart_apb_seq_item.sv"

class apb_uart_apb_dvr;

  virtual apb_if intf;

  mailbox #(apb_uart_apb_seq_item) mbx;

  virtual function void connect_intf(virtual apb_if intf);
    this.intf = intf;
  endfunction

  virtual function void connect_mbx(mailbox #(apb_uart_apb_seq_item) mbx);
    this.mbx = mbx;
  endfunction

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
