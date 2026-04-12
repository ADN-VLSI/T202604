module dumpfile_example;
  initial begin
    $dumpfile("signals.vcd"); // Creates a VCD file named 'signals.vcd' in the simulation directory
    $dumpvars; // Enable dumping of all variables in the design (for simplicity in this example)
    #100 $finish;
  end
endmodule