module clk_freq_div #(
    parameter DIV_WIDTH = 20
) (
    input  logic                 arst_ni,
    input  logic                 clk_i,
    input  logic [DIV_WIDTH-1:0] div_i,
    output logic                 en_o
);

  logic [DIV_WIDTH-1:0] cnt_q;

  always_comb en_o = (div_i <= 1) | (cnt_q == div_i - 1'b1);

  always_ff @(posedge clk_i or negedge arst_ni) begin
    if (!arst_ni) begin
      cnt_q <= '0;
    end else begin
      if ((div_i <= 1) || (cnt_q == div_i - 1'b1)) begin
        cnt_q <= '0;
      end else begin
        cnt_q <= cnt_q + 1'b1;
      end
    end
  end

endmodule
