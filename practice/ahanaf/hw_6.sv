module hw_6;
initial begin
  $display("Start Time: %0t ns", $time);
  #25ns $display("Time after 25ns delay: %0t ns", $time);
  #75ns $display("Time after another 75ns delay: %0t ns", $time);
end
// Solution Output (Time values will accumulate):
// Start Time: 0 ns
// Time after 25ns delay: 25 ns
// Time after another 75ns delay: 100 ns

endmodule