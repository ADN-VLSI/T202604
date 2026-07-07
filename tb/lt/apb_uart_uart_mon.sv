// @foez-bhai, add commnents describing this file and its functions

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
        logic direction;
        logic [ADDR_WIDTH-1:0] address;
        logic [DATA_WIDTH-1:0] write_data;
        logic [DATA_WIDTH/8-1:0] write_strobe;
        logic [DATA_WIDTH-1:0] read_data;
        logic slverr;
        intf.get_transaction( direction, address, write_data, write_strobe, read_data, slverr);
        item = new();
        item.write = direction;
        item.addr  = address;
        item.data  = direction ? write_data : read_data;
        item.slverr = slverr;
        mbx.put(item);
      end
    join_none
  endtask

endclass

`endif

