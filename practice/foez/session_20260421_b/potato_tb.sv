// | Opcode | Operation   |
// |--------|-------------|
// | 3'b000 | OR          |
// | 3'b001 | AND         |
// | 3'b011 | XOR         |
// | 3'b100 | NOR         |
// | 3'b101 | NAND        |
// | 3'b111 | XNOR        |

module potato_tb;

  logic [3:0] tb_a;
  logic [3:0] tb_b;
  logic [2:0] tb_op;
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
    casex (tb_op)

      3'b000:
      if (tb_c !== (tb_a | tb_b)) begin
        $fatal(1, "Error: OR  operation failed for a=%b, b=%b, c=%b", tb_a, tb_b, tb_c);
      end

      3'b001:
      if (tb_c !== (tb_a & tb_b)) begin
        $fatal(1, "Error: AND operation failed for a=%b, b=%b, c=%b", tb_a, tb_b, tb_c);
      end

      3'b010: begin
      end

      3'b011:
      if (tb_c !== (tb_a ^ tb_b)) begin
        $fatal(1, "Error: XOR operation failed for a=%b, b=%b, c=%b", tb_a, tb_b, tb_c);
      end

      3'b100:
      if (tb_c !== ~(tb_a | tb_b)) begin
        $fatal(1, "Error: NOR  operation failed for a=%b, b=%b, c=%b", tb_a, tb_b, tb_c);
      end

      3'b101:
      if (tb_c !== ~(tb_a & tb_b)) begin
        $fatal(1, "Error: NAND operation failed for a=%b, b=%b, c=%b", tb_a, tb_b, tb_c);
      end

      3'b110: begin
      end

      3'b111:
      if (tb_c !== ~(tb_a ^ tb_b)) begin
        $fatal(1, "Error: XNOR operation failed for a=%b, b=%b, c=%b", tb_a, tb_b, tb_c);
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
