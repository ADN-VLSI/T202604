module hw_8;

initial begin
  #100ns $display("Simulation finished after 100ns.");
  $finish;
end
// Solution: Simulation will run for 100ns, print the message, and then terminate.
endmodule