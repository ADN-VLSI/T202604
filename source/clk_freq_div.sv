module clk_freq_div #(
    parameter DIV_WIDTH = 20
) (
    input  logic                 arst_ni,
    input  logic                 clk_i,
    input  logic [DIV_WIDTH-1:0] div_i,
    output logic                 en_o
);

  logic [DIV_WIDTH-1:0] count_q;

  always_comb en_o = (div_i == '0) | (div_i == 1) | (count_q == '0);

  always_ff @(negedge clk_i or negedge arst_ni) begin

    if (!arst_ni) begin
      count_q <= '0;
    end else begin

      if ((div_i == '0) | (div_i == 1)) begin
        count_q <= '0;
      end else if (count_q == '0) begin
        count_q <= div_i - 'd1;
      end else begin
        count_q <= count_q - 'd1;
      end

    end
  end

endmodule
