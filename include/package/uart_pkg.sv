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

  localparam int ZEROS            = 0;
  localparam int UART_EN_IDX      = (1 << 0);
  localparam int TX_FLUSH_IDX     = (1 << 1);
  localparam int RX_FLUSH_IDX     = (1 << 2);

  localparam int CLK_DIV_IDX         = 'd0;
  localparam int PARITY_EN_IDX       = 'd12;
  localparam int PARITY_TYPE_IDX     = 'd13;
  localparam int SECOND_STOP_BIT_IDX = 'd14;

endpackage

`endif
