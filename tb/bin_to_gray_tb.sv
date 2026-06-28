module bin_to_gray_tb;

  localparam int WIDTH = 4;

  logic [WIDTH-1:0] bin;
  logic [WIDTH-1:0] gray;

  logic dummy_clk;
  logic is_aligned;

  int pass = 0;
  int fail = 0;

  always @(posedge dummy_clk) begin
    is_aligned = 1;
    #1;
    is_aligned = 0;
  end

  bin_to_gray #(
      .N(WIDTH)
  ) dut (
      .bin_i (bin),
      .gray_o(gray)
  );

  task automatic apply_reset(input realtime duration = 100ns);
    #(duration);
    dummy_clk <= '0;
    #(duration);
    dummy_clk <= '1;
    #(duration);
  endtask

  task automatic start_clock(input realtime tp = 10ns);
    fork
      forever begin
        #(tp / 2) dummy_clk <= ~dummy_clk;
      end
    join_none
  endtask

  task automatic drive(input logic [WIDTH-1:0] value = $urandom);
    wait (is_aligned);
    bin <= value;
    @(posedge dummy_clk);
  endtask

  task automatic monitor(output logic [WIDTH-1:0] bin_value, output logic [WIDTH-1:0] gray_value);
    @(posedge dummy_clk);
    bin_value  = bin;
    gray_value = gray;
  endtask

  function automatic logic [WIDTH-1:0] bin_to_gray_func(input logic [WIDTH-1:0] bin_value);
    return (bin_value ^ (bin_value >> 1));
  endfunction

  task automatic check(input logic [WIDTH-1:0] bin_value, input logic [WIDTH-1:0] gray_value);
    logic [WIDTH-1:0] expected_gray;
    expected_gray = bin_to_gray_func(bin_value);
    if (gray_value === expected_gray) begin
      pass++;
    end else begin
      fail++;
      $display("Mismatch: bin=%0d, gray=%0d, expected_gray=%0d", bin_value, gray_value,
               expected_gray);
    end
  endtask

  initial begin
    $dumpfile("bin_to_gray_tb.vcd");
    $dumpvars(0, bin_to_gray_tb);

    apply_reset();
    start_clock();
    fork

      repeat (100) @(posedge dummy_clk);

      forever begin
        drive();
      end

      forever begin
        logic [WIDTH-1:0] bv;
        logic [WIDTH-1:0] gv;
        monitor(bv, gv);
        check(bv, gv);
      end

    join_any

    $display("Test completed: pass=%0d, fail=%0d", pass, fail);
    if (fail == 0) begin
      $display("Test passed!");
    end else begin
      $display("Test failed.");
    end

    $finish;
  end

endmodule
