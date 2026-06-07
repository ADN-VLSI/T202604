module clk_freq_div #(
    parameter DIV_WIDTH = 20
) (
    input  logic                 arst_ni,
    input  logic                 clk_i,
    input  logic [DIV_WIDTH-1:0] div_i,
    output logic                 en_o,
    output logic                 clk_o   // New output based on whiteboard sketch
);

  // Counter register to keep track of clock cycles
  logic [DIV_WIDTH-1:0] count;

  // Single sequential block for counting and enable generation
  always_ff @(posedge clk_i or negedge arst_ni) begin
    if (!arst_ni) begin
      count <= '0;
      en_o  <= '0;
    end else if (div_i == '0) begin
      count <= '0;
      en_o  <= '0;
    end else if (count == div_i) begin
      count <= '0;   // Reset counter when target division factor is reached
      en_o  <= '1;   // Assert enable pulse for exactly 1 clock cycle
    end else begin
      count <= count + 1'b1; // Increment counter in normal states
      en_o  <= '0;   // Keep enable low
    end
  end

  // Gated Clock Generation based on whiteboard sketch:
  // clk_i passes through to clk_o only when en_o is asserted (HIGH)
  assign clk_o = clk_i & en_o;

endmodule
