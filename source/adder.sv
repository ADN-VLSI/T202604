////////////////////////////////////////////////////////////////////////////////////////////////////
//
// Module: adder
// Description: A simple combinational adder that computes the sum of two
//              N-bit operands. The result is also N bits, ignoring any
//              carry-out.
//
////////////////////////////////////////////////////////////////////////////////////////////////////
module adder #(
    parameter int WIDTH = 8  // Width of the input operands and the output sum
) (
    // Inputs
    input logic [WIDTH-1:0] opa_i,  // First operand
    input logic [WIDTH-1:0] opb_i,  // Second operand

    // Output
    output logic [WIDTH-1:0] sum_o  // Sum of opa_i and opb_i (truncated to WIDTH)
);

  // Combinational logic for addition.
  // The '+' operator performs binary addition. The result is assigned to sum_o.
  // Note: Any carry-out bit from the addition is discarded as sum_o has the
  // same width as the operands.
  always_comb begin
    sum_o = opa_i + opb_i;
  end

endmodule
