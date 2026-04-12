module monitor_example;
  reg [3:0] a, b;

  initial begin
    $monitor("Time=%0t ns: a=%0d, b=%0d", $time, a, b); // Start monitoring a and b
    a = 0; b = 0;
    #5 a = 5;      // Value of 'a' changes, triggers $monitor
    #5 b = 10;     // Value of 'b' changes, triggers $monitor again
    #5 $monitoroff; // Stop monitoring
    #5 a = 7;      // No output, $monitor is off
  end
endmodule