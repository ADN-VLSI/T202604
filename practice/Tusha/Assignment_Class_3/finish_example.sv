module finish_example;
  initial begin
    #10ns $display("Simulation about to finish.");
    $finish; // Ends simulation execution here
    $display("This line will NOT be printed."); // Simulation terminated above
  end
endmodule