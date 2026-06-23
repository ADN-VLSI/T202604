`include "uvm_macros.svh"

import uvm_pkg::*;

`include "test/base_test.sv"

module uvm_tb;

  string test_name;

  ctrl_if ctrl_intf ();

  apb_if apb_intf (
      .arst_ni(ctrl_intf.arst_ni),
      .clk_i  (ctrl_intf.clk_i)
  );

  uart_if uart_intf ();

  initial begin
    $dumpfile("uvm_tb.vcd");
    $dumpvars(0, uvm_tb);

    test_name = "base_test";

    uvm_config_db#(string)::set(uvm_root::get(), "test", "name", test_name);

    uvm_config_db#(virtual ctrl_if)::set(uvm_root::get(), "ctrl", "intf", ctrl_intf);
    uvm_config_db#(virtual apb_if)::set(uvm_root::get(), "apb", "intf", apb_intf);
    uvm_config_db#(virtual uart_if)::set(uvm_root::get(), "uart", "intf", uart_intf);

    run_test(test_name);

    #10us;
    $finish;
  end

endmodule
