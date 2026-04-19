module stime_example;
  initial begin
    #100000ns;
    $display("32-bit Time: %0d ns", $stime);
    // Output: "32-bit Time: 100000 ns" (May truncate or wrap in very long simulations)
  end
endmodule