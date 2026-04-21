// | Opcode | Operation   |
// |--------|-------------|
// | 2'b00  | Bitwise OR  |
// | 2'b01  | Bitwise AND |
// | 2'b10  | Addition    |
// | 2'b11  | Bitwise XOR |

module potato_tb;

  logic [3:0] tb_a;
  logic [3:0] tb_b;
  logic [1:0] tb_op;
  logic [3:0] tb_c;

  potato dut (
    .a(tb_a),
    .b(tb_b),
    .op(tb_op),
    .c(tb_c)
  );

  initial begin
   
    // Test case 1: Addition
    tb_a  = 3;
    tb_b  = 5;
    tb_op = 2; // Addition
    #10;

    // TODO : Add more test cases for other operations (Bitwise OR, Bitwise AND, Bitwise XOR)

    $finish;

  end

endmodule
