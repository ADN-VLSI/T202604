module hw_3;
reg a, b, result_strobe, result_display;
assign result_strobe = a & b;
assign result_display = a | b;

initial begin
  a = 0; b = 0;
  #5 a = 1; b = 1; // a and b change at the same time
  $strobe("Strobe: Time=%0t, AND=%b", $time, result_strobe); // Stable AND value
  $display("Display: Time=%0t, OR=%b", $time, result_display); // Potentially intermediate OR value
end
// Solution Output (Order may vary slightly depending on simulator):
// Display: Time=5, OR=0  // May show intermediate value if display happens before assignment settles
// Strobe: Time=5, AND=1   // Shows stable AND value at the end of time step

endmodule