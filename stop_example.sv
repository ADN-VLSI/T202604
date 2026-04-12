module stop_example;
  initial begin
    #20ns $display("Pausing simulation...");
    $stop; // Simulation pauses at time 20ns
    #10ns $display("Simulation Resumed."); // Only executed if you manually resume
  end
endmodule