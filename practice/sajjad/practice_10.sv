module practice_10;

initial begin
  #10ns $display("Attempting to exit simulator...");
  $exit; // Simulator will likely terminate immediately after this point
  $display("This may or may not print."); // Execution might stop before reaching here
end
// Solution: Running this will likely terminate your simulator abruptly around 10ns. Observe the simulator's behavior.

endmodule