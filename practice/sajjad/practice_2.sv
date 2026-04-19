module practice_2;

reg [3:0] count;
reg enable;
initial begin
  $monitor("Time=%0t: Count=%0d, Enable=%b", $time, count, enable);
  count = 0; enable = 0;
  #5 count = 5;
  #5 enable = 1;
end
// Solution Output:
// Time=0: Count=x, Enable=0
// Time=5: Count=5, Enable=0
// Time=10: Count=5, Enable=1

endmodule