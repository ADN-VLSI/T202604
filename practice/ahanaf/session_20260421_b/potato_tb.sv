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
      .a (tb_a),
      .b (tb_b),
      .op(tb_op),
      .c (tb_c)
  );

  function automatic void load_random();
    tb_a  <= $urandom;
    tb_b  <= $urandom;
    tb_op <= $urandom;
  endfunction

  function automatic void check();
    case (tb_op)

      2'b00:
      if (tb_c !== (tb_a | tb_b)) begin
        $fatal(1, "Error: OR  operation failed for a=%b, b=%b, c=%b", tb_a, tb_b, tb_c);
      end

      2'b01:
      if (tb_c !== (tb_a & tb_b)) begin
        $fatal(1, "Error: AND operation failed for a=%b, b=%b, c=%b", tb_a, tb_b, tb_c);
      end

      2'b10:
      if (tb_c !== (4'b1111 & (tb_a + tb_b))) begin
        $fatal(1, "Error: ADD operation failed for a=%b, b=%b, c=%b", tb_a, tb_b, tb_c);
      end

      2'b11:
      if (tb_c !== (tb_a ^ tb_b)) begin
        $fatal(1, "Error: XOR operation failed for a=%b, b=%b, c=%b", tb_a, tb_b, tb_c);
      end

      default: $fatal(1, "Error: Invalid opcode %b", tb_op);

    endcase
  endfunction

  initial begin

    repeat (100) begin
      load_random();
      #10;
      check();
    end

    $display("All tests passed.");

    $finish;

  end

endmodule
