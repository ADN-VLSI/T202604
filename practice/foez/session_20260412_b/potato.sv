module potato (
    input logic [3:0] a,
    input logic [3:0] b,
    input logic [1:0] op,

    output logic [3:0] c
);

  always_comb begin
    case (op)
      2'b00:   c = a | b;  // Bitwise OR
      2'b01:   c = a & b;  // Bitwise AND
      2'b10:   c = a + b;  // Addition
      2'b11:   c = a ^ b;  // Bitwise XOR
      default: c = 4'b0000;
    endcase
  end

endmodule
