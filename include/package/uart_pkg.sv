`ifndef UART_PKG_SV
`define UART_PKG_SV 0

package uart_pkg;

  localparam int ADDR_WIDTH = 5;
  localparam int DATA_WIDTH = 32;

  // UART Register Map
  localparam int UART_CTRL_OFFSET    = 'h00;
  localparam int UART_CFG_OFFSET     = 'h04;
  localparam int UART_STAT_OFFSET    = 'h08;
  localparam int UART_TX_DATA_OFFSET = 'h0C;
  localparam int UART_RX_DATA_OFFSET = 'h10;

endpackage

`endif
