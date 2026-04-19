module hw_4;
    module wave_module;
  reg clock;
  initial begin
    $dumpfile("my_wave.vcd");
    $dumpvars(0, wave_module);
    clock = 0;
    forever #10 clock = ~clock;
  end
  initial begin
    #1000;
    $finish;
  end
endmodule
// Solution: Simulating this will create 'my_wave.vcd' in your simulation directory. Open it with a waveform viewer to see the 'clock' signal.

endmodule