module regif (
    input logic arst_ni,
    input logic clk_i,

    input  logic [ 2:0] addr_i,
    input  logic [31:0] wdata_i,
    input  logic        we_i,
    output logic [31:0] rdata_o,
    output logic        error_o,

    input  logic [31:0] reg0_i,  // 0x0 RO
    input  logic [31:0] reg1_i,  // 0x1 RO
    input  logic [31:0] reg2_i,  // 0x2 RO
    input  logic [31:0] reg3_i,  // 0x3 RO
    output logic [31:0] reg4_o,  // 0x4 RW
    output logic [31:0] reg5_o,  // 0x5 RW
    output logic [31:0] reg6_o,  // 0x6 RW
    output logic [31:0] reg7_o   // 0x7 RW
);

  // YOUR CODE HERE

endmodule
