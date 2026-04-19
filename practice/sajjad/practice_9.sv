module practice_9;

initial begin
  #50ns $display("Simulation about to pause at 50ns.");
  $stop;
  #50ns $display("This line will only print if simulation is resumed.");
end
// Solution: Simulation will pause at 50ns. In interactive simulators, you can then manually resume to see the second display message.

endmodule