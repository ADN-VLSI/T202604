module bin_to_gray #(
    parameter N = 4
) (
    input  logic [N-1:0] bin_i,
    output logic [N-1:0] gray_o
);

  always_comb gray_o[N-1] = bin_i[N-1];

  for (genvar i = 0; i < (N - 1); i++) begin
    always_comb gray_o[i] = bin_i[i+1] ^ bin_i[i];
  end

endmodule
