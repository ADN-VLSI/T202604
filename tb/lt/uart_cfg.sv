`ifndef __GUARD_UART_CFG__
`define __GUARD_UART_CFG__ 0

class uart_cfg;

  int  BAUD_RATE = 115200;
  bit  PARITY_ENABLE = 0;
  bit  PARITY_TYPE = 1;
  bit  SECOND_STOP_BIT = 0;
  int  DATA_BITS = 8;

endclass

`endif
