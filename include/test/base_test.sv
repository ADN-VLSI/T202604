`ifndef __GUARD_BASE_TEST_SV__
`define __GUARD_BASE_TEST_SV__ 0

`include "component/apb_uart_env.sv"

class base_test extends uvm_test;

  `uvm_component_utils(base_test)

  virtual ctrl_if ctrl_intf;
  virtual apb_if  apb_intf;
  virtual uart_if uart_intf;

  apb_uart_env env;

  function new(string name = "base_test", uvm_component parent = null);
    super.new(name, parent);
  endfunction

  virtual function void build_phase(uvm_phase phase);
    super.build_phase(phase);
    env = apb_uart_env::type_id::create("env", this);
  endfunction

  virtual function void connect_phase(uvm_phase phase);
    super.connect_phase(phase);

    if (!uvm_config_db#(virtual ctrl_if)::get(uvm_root::get(), "ctrl", "intf", ctrl_intf)) begin
      `uvm_fatal(
          "CONNECT_PHASE",
          "Virtual interface ctrl_intf is not set. Please set it in the testbench or configuration database.")
    end

    if (!uvm_config_db#(virtual apb_if)::get(uvm_root::get(), "apb", "intf", apb_intf)) begin
      `uvm_fatal(
          "CONNECT_PHASE",
          "Virtual interface apb_intf is not set. Please set it in the testbench or configuration database.")
    end

    if (!uvm_config_db#(virtual uart_if)::get(uvm_root::get(), "uart", "intf", uart_intf)) begin
      `uvm_fatal(
          "CONNECT_PHASE",
          "Virtual interface uart_intf is not set. Please set it in the testbench or configuration database.")
    end

  endfunction

  virtual function void end_of_elaboration_phase(uvm_phase phase);
    super.end_of_elaboration_phase(phase);
    $display("\033[1;33m");
    uvm_top.print_topology();
    $display("\033[0m");
  endfunction

endclass

`endif
