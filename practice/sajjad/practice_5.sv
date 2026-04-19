module practice_5;

module dump_select_module;
  reg signal_A, signal_B, signal_C;
  initial begin
    $dumpfile("select_wave.vcd");
    $dumpvars(1, signal_A); // Only dump signal_A (top-level, level 1)
    signal_A = 0; signal_B = 0; signal_C = 0;
    #10 signal_A = 1; #10 signal_B = 1; #10 signal_C = 1;
    #50 $finish;
  end
endmodule
// Solution: 'select_wave.vcd' will only contain waveform data for 'signal_A'.


endmodule