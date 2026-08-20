`ifndef __GUARD_BASE_TEST_SV__
`define __GUARD_BASE_TEST_SV__ 0

class base_test extends uvm_test;

  `uvm_component_utils(base_test)

  virtual ctrl_intf intf;

  function new(string name = "base_test", uvm_component parent = null);
    super.new(name, parent);
  endfunction

  virtual function void build_phase(uvm_phase phase);
    super.build_phase(phase);
  endfunction

  virtual function void connect_phase(uvm_phase phase);
    super.connect_phase(phase);
    if (!uvm_config_db#(virtual ctrl_intf)::get(uvm_root::get(), "ctrl", "vif", intf)) begin
      `uvm_fatal("NOVIF", $sformatf("Virtual interface must be set for: %s", get_full_name()))
    end
  endfunction

  virtual task run_phase(uvm_phase phase);
    super.run_phase(phase);
    uvm_top.print_topology();
  endtask

  virtual task reset_phase(uvm_phase phase);
    super.reset_phase(phase);
    phase.raise_objection(this);
    intf.apply_reset();
    phase.drop_objection(this);
  endtask

endclass

`endif
