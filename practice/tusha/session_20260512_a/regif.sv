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
always_ff @(posedge clk_i or negedge arst_ni) begin
   if (~arst_ni) begin
      //rdata_o <= '0;
      reg4_o <= '0;
      reg5_o <= '0;
      reg6_o <= '0;
      reg7_o <= '0;
    end else if (we_i) begin
      case (addr_i)
        3'h4: reg4_o <= wdata_i;
        3'h5: reg5_o <= wdata_i;
        3'h6: reg6_o <= wdata_i;
        3'h7: reg7_o <= wdata_i;
        default: begin
          // No write for invalid addresses, keep current values
        end 
        endcase
    end
  end
    always_comb begin
      //rdata_o = '0;  // Default value for rdata_o
      if (~we_i) begin
        case (addr_i)
          3'h0: rdata_o = reg0_i;
          3'h1: rdata_o = reg1_i;
          3'h2: rdata_o = reg2_i;
          3'h3: rdata_o = reg3_i;
          3'h4: rdata_o = reg4_o;
          3'h5: rdata_o = reg5_o;      
          3'h6: rdata_o = reg6_o;
          3'h7: rdata_o = reg7_o;
          default: rdata_o = '0;
        endcase
        
      end
    end
    

assign error_o = we_i && (addr_i <= 3'h3);  // Error if write to invalid address

endmodule
