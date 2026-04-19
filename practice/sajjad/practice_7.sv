module practice_7;
initial begin
  #12.345ns $display("Real Time with precision: %0.3f ns", $realtime);
end
// Solution Output: "Real Time with precision: 12.345 ns"

endmodule