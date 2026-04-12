module dumpvars_example;
  reg clk, enable;
  wire out;
  assign out = clk & enable;

  initial begin
    $dumpfile("waveform.vcd");
    $dumpvars(0, dumpvars_example); // Dump ALL variables and signals in this module and below
    clk = 0;
    enable = 1;
    forever #5 clk = ~clk;    
  end
  
  initial begin
    #1000;
    $finish;    
  end

endmodule