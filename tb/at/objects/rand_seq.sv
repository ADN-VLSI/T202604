`ifndef __GUARD_RAND_SEQ_SV__
`define __GUARD_RAND_SEQ_SV__ 0

`include "at/objects/seq_item.sv"

class rand_seq extends uvm_sequence #(seq_item);

  `uvm_object_utils(rand_seq)

  int TEST_LEN;

  function new(string name = "rand_seq");
    super.new(name);
  endfunction

  virtual task body();
    uvm_config_db#(int)::get(uvm_root::get(), "dut", "test_len", TEST_LEN);
    repeat (TEST_LEN) begin
      `uvm_do(req)
    end
  endtask

endclass

`endif
