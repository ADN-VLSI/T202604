module time_example;
  initial begin
    #7.5ns;
    $display("64-bit Time: %0t ns", $time);
    // Output: "64-bit Time: 7 ns" (Time unit depends on `timescale directive`)
  end
endmodule