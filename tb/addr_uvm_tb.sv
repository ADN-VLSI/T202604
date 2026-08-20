`include "uvm_macros.svh"

import uvm_pkg::*;

module addr_uvm_tb;

  // Display messages at the very beginning and end of the simulation for clarity.
  initial $display("\033[7;38m TEST STARTED \033[0m");
  final $display("\033[7;38m TEST ENDED \033[0m");

  //////////////////////////////////////////////////////////////////////////////////////////////////
  // Parameters
  //////////////////////////////////////////////////////////////////////////////////////////////////

  // Define local parameters for the DUT configuration.
  localparam int WIDTH = 8;
  localparam int INPUT_FIFO_SIZE = 4;
  localparam int OUTPUT_FIFO_SIZE = 4;

  //////////////////////////////////////////////////////////////////////////////////////////////////
  // VARIABLE
  //////////////////////////////////////////////////////////////////////////////////////////////////

  string test_name;

  //////////////////////////////////////////////////////////////////////////////////////////////////
  // Interfaces
  //////////////////////////////////////////////////////////////////////////////////////////////////

  // Control interface for clock and reset.
  ctrl_intf ctrl_if ();

  // Data interfaces for the two inputs (opa, opb) and the output (sum).
  // These interfaces bundle the data, valid, and ready signals.
  data_intf intf_opa (
      .arst_ni(ctrl_if.arst_n),
      .clk_i  (ctrl_if.clk)
  );

  data_intf intf_opb (
      .arst_ni(ctrl_if.arst_n),
      .clk_i  (ctrl_if.clk)
  );

  data_intf intf_sum (
      .arst_ni(ctrl_if.arst_n),
      .clk_i  (ctrl_if.clk)
  );

  //////////////////////////////////////////////////////////////////////////////////////////////////
  // DUT Instantiation
  //////////////////////////////////////////////////////////////////////////////////////////////////

  // Instantiate the top-level design module.
  adder_top #(
      .WIDTH           (WIDTH),
      .INPUT_FIFO_SIZE (INPUT_FIFO_SIZE),
      .OUTPUT_FIFO_SIZE(OUTPUT_FIFO_SIZE)
  ) u_adder_top (
      // Connect DUT ports to the top-level signals.
      .arst_ni    (ctrl_if.arst_n),
      .clk_i      (ctrl_if.clk),
      // Operand A
      .opa_i      (intf_opa.data),
      .opa_valid_i(intf_opa.valid),
      .opa_ready_o(intf_opa.ready),
      // Operand B
      .opb_i      (intf_opb.data),
      .opb_valid_i(intf_opb.valid),
      .opb_ready_o(intf_opb.ready),
      // Sum
      .sum_o      (intf_sum.data),
      .sum_valid_o(intf_sum.valid),
      .sum_ready_i(intf_sum.ready)
  );

  //////////////////////////////////////////////////////////////////////////////////////////////////
  // Procedural Blocks
  //////////////////////////////////////////////////////////////////////////////////////////////////

  // This initial block sets up the entire UVM test environment and starts the test.
  initial begin

    // This sets the time format for the simulation output, showing time in nanoseconds.
    $timeformat(-9, 0, "ns", 0);

    // This sets up the VCD (Value Change Dump) file for waveform viewing.
    $dumpfile("addr_uvm_tb.vcd");
    $dumpvars(0, addr_uvm_tb);

    // Get the test name from the command line arguments (+test_name=<your_test>).
    // If not provided, the simulation will exit with a fatal error.
    if (!$value$plusargs("TEST_NAME=%s", test_name)) begin
      $fatal(1, "No test name provided. Use make ... TN=<test_name> to specify a test.");
    end

    // Use the uvm_config_db to pass configuration values down the hierarchy.
    // These values can be retrieved by any component in the test environment.

    // Pass DUT parameters.
    uvm_config_db#(int)::set(uvm_root::get(), "dut", "data_width", WIDTH);

    // Pass the virtual interfaces to the test environment. This is how the
    // UVM components (driver, monitor) interact with the DUT.
    uvm_config_db#(virtual ctrl_intf)::set(uvm_root::get(), "ctrl", "vif", ctrl_if);
    uvm_config_db#(virtual data_intf)::set(uvm_root::get(), "opa", "vif", intf_opa);
    uvm_config_db#(virtual data_intf)::set(uvm_root::get(), "opb", "vif", intf_opb);
    uvm_config_db#(virtual data_intf)::set(uvm_root::get(), "sum", "vif", intf_sum);

    uvm_config_db::dump();

    // // Start the UVM test. This function creates the test component specified
    // // by 'test_name' and starts the UVM phasing mechanism.
    // run_test(test_name);

    // End the simulation once the test is complete.
    $finish;

  end

endmodule
