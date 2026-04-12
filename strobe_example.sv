module strobe_example;
  int a;

  initial begin
    a = 42;          // blocking: takes effect immediately
    a <= 65;         // non-blocking: scheduled for end of time step
    $display("Display says a is %0d", a); // prints 42 (non-blocking not yet settled)
    $strobe("Strobe says a is %0d", a);   // prints 65 (after non-blocking settles)
    #10ns;
    $finish;
  end
endmodule