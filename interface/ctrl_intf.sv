//----------------------------------------------------------------------
// ctrl_intf.sv
//
// This file defines a simple control interface containing the primary
// clock and reset signals for the testbench and DUT.
//----------------------------------------------------------------------

interface ctrl_intf;

  // The main clock signal for the design and testbench.
  logic clk;

  // The active-low asynchronous reset signal.
  logic arst_n;

  // The clock period for the design, used for timing calculations.
  realtime timeperiod = 10ns;

  // The clock enable signal, which can be used to control clock gating.
  bit clk_en = 0;

  // Applies an active-low asynchronous reset sequence.
  // This task drives the `arst_n` signal low for a specified `duration`
  // to reset the DUT. It includes optional delays before and after
  // the reset pulse.
  task static apply_reset(input realtime duration = 100ns, input realtime pre_delay = duration,
                          input realtime post_delay = pre_delay);
    #(pre_delay);
    arst_n <= 1'b0;
    #(duration);
    arst_n <= 1'b1;
    #(post_delay);
  endtask

  // Enables the clock generation.
  // Sets the internal `clk_en` signal to 1, allowing the clock
  // generator to start toggling the `clk` signal.
  function void start_clock();
    clk_en = 1'b1;
  endfunction

  // Disables the clock generation.
  // Clears the internal `clk_en` signal to 0, which stops the
  // clock and holds it at a low level.
  function void stop_clock();
    clk_en = 1'b0;
  endfunction

  // Clock Generator Block
  //
  // This `initial` block contains the continuous clock generation logic.
  //
  // The clock has a period defined by `timeperiod`. It is gated and will only
  // toggle when both the clock enable (`clk_en`) and the active-high version
  // of the reset (`arst_n`) are asserted. This ensures the clock remains
  // stable and low during reset or when explicitly disabled via `stop_clock()`.
  //
  // A safety check prevents simulation errors by ensuring time delays
  // are never zero or negative if `timeperiod` is not configured properly.
  initial begin
    forever begin
      clk <= clk_en & arst_n;
      if (timeperiod > 1ps) #(timeperiod / 2);
      else #(1ps);
      clk <= 1'b0;
      if (timeperiod > 1ps) #(timeperiod / 2);
      else #(1ps);
    end
  end

endinterface
