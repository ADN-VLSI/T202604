module potato (
    input logic [3:0] a,
    input logic [3:0] b,
    input logic [2:0] op,

    output logic [3:0] c
);

  always_comb begin
    case (op)
      3'b000:   c = a | b;    // Bitwise OR
      3'b001:   c = a & b;    // Bitwise AND
      3'b011:   c = a ^ b;    // Bitwise XOR
      3'b100:   c = ~(a | b); // NOR
      3'b101:   c = ~(a & b); // NAND
      3'b111:   c = ~(a ^ b); // XNOR
      default: c = 4'b0000;
    endcase
  end

endmodule
