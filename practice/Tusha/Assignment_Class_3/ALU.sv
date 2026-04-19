module ALU(
    input logic [3:0] A, B,
    input logic [2:0] opcode,
    output logic [3:0] out
);

always_comb begin
    case (opcode)
        3'b000: out = A + B;
        3'b001: out = A - B;
        3'b010: out = A & B;
        3'b011: out = A | B;
        3'b100: out = A ^ B;
        default: out = 4'b0000;
    endcase
end

endmodule