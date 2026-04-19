module realtime_example;
  initial begin
    #3.75ns;
    $display("Real Time: %0.2f ns", $realtime);
    // Output: "Real Time: 3.75 ns"
  end
endmodule