module gray_to_bin #(
    parameter N = 4
) (
    input  logic [N-1:0] gray_i,
    output logic [N-1:0] bin_o
);

  always_comb bin_o[N-1] = gray_i[N-1];

  for (genvar i = 0; i < (N - 1); i++) begin
    always_comb bin_o[i] = gray_i[i] ^ bin_o[i+1];
  end

endmodule
