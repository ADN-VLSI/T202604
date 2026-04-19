module exit_example;
  initial begin
    #5ns $display("Exiting simulator abruptly...");
    $exit; // Simulator terminates immediately, potentially without full cleanup
    $display("This line may or may not be printed, depending on the tool.");
  end
endmodule