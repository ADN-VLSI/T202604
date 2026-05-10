module generic_dp_mem #(
    parameter int ADDR_WIDTH = 3,
    parameter int DATA_WIDTH = 32
) (
    input logic clk_i,

    input logic [ADDR_WIDTH-1:0] waddr_i,
    input logic [DATA_WIDTH-1:0] wdata_i,
    input logic                  we_i,

    input  logic [ADDR_WIDTH-1:0] raddr_i,
    output logic [DATA_WIDTH-1:0] rdata_o
);

  logic [DATA_WIDTH-1:0] mem[2**ADDR_WIDTH];

  always_comb rdata_o = mem[raddr_i];

  always_ff @(posedge clk_i) begin
    if (we_i) begin
      mem[waddr_i] <= wdata_i;
    end
  end

endmodule
