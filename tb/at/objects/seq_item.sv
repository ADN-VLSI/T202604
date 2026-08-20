`ifndef __GUARD_SEQ_ITEM_SV__
`define __GUARD_SEQ_ITEM_SV__ 0

class seq_item extends uvm_sequence_item;

  `uvm_object_utils(seq_item)

  int WIDTH;

  rand bit [127:0] data;

  function new(string name = "seq_item");
    super.new(name);
  endfunction

  virtual function void pre_randomize();
    uvm_config_db#(int)::get(uvm_root::get(), "dut", "data_width", WIDTH);
  endfunction

  virtual function void post_randomize();
    for (int i = WIDTH; i < 128; i++) begin
      data[i] = 0;
    end
  endfunction

endclass

`endif
