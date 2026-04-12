module display_example;
  initial begin
    integer value = 42;
    $display("[%0t ns] Value = %0d (binary: %b, hex: %0h)", $time, value, value, value);
    // Output (at time 0): "[0 ns] Value = 42 (binary: 101010, hex: 2a)"
  end
endmodule