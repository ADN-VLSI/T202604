module cdc_fifo #(
    parameter int DATA_WIDTH = 8,
    parameter int SIZE = 4
) (

    input  logic                  data_in_arst_ni,
    input  logic                  data_in_clk_i,
    input  logic [DATA_WIDTH-1:0] data_in_i,
    input  logic                  data_in_valid_i,
    output logic                  data_in_ready_o,

    input  logic                  data_out_arst_ni,
    input  logic                  data_out_clk_i,
    output logic [DATA_WIDTH-1:0] data_out_o,
    output logic                  data_out_valid_o,
    input  logic                  data_out_ready_i

);

  logic [SIZE:0] wr_addr;
  logic          wr_en;

  logic [SIZE:0] rd_addr;

  generic_dp_mem #(
      .ADDR_WIDTH(SIZE),
      .DATA_WIDTH(DATA_WIDTH)
  ) mem (
      .clk_i  (data_in_clk_i),
      .waddr_i(wr_addr[SIZE-1:0]),
      .wdata_i(data_in_i),
      .we_i   (wr_en),
      .raddr_i(rd_addr[SIZE-1:0]),
      .rdata_o(data_out_o)
  );

  bin_to_gray #(
    .N(SIZE+1)
) (
    .bin_i(wr_addr),
    .gray_o()
);

endmodule
