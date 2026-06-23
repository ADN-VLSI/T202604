`ifndef __GUARD_APB_UART_ENV_SV__
`define __GUARD_APB_UART_ENV_SV__ 0

class apb_uart_env extends uvm_env;

  `uvm_component_utils(apb_uart_env)

  function new(string name = "apb_uart_env", uvm_component parent = null);
    super.new(name, parent);
  endfunction

endclass

`endif
