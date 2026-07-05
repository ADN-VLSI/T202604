module layered_tb;

  `include "lt/apb_uart_apb_seq_item.sv"
  `include "lt/apb_uart_apb_rsp_item.sv"
  `include "lt/apb_uart_apb_dvr.sv"

  //////////////////////////////////////////////////////////////////////////////////////////////////
  // Parameters
  //////////////////////////////////////////////////////////////////////////////////////////////////

  import uart_pkg::ADDR_WIDTH;
  import uart_pkg::DATA_WIDTH;

  //////////////////////////////////////////////////////////////////////////////////////////////////
  // Interfaces
  //////////////////////////////////////////////////////////////////////////////////////////////////

  ctrl_if ctrl_intf ();

  apb_if apb_intf (
      .arst_ni(ctrl_intf.arst_ni),
      .clk_i  (ctrl_intf.clk_i)
  );

  uart_if uart_intf ();

  //////////////////////////////////////////////////////////////////////////////////////////////////
  // Classes
  //////////////////////////////////////////////////////////////////////////////////////////////////

  mailbox #(apb_uart_apb_seq_item) apb_dvr_mbx = new(1);

  apb_uart_apb_dvr apb_dvr;

  //////////////////////////////////////////////////////////////////////////////////////////////////
  // DUT
  //////////////////////////////////////////////////////////////////////////////////////////////////

  apb_uart_top u_dut (
      .arst_ni  (ctrl_intf.arst_ni),
      .clk_i    (ctrl_intf.clk_i),
      .psel_i   (apb_intf.psel),
      .penable_i(apb_intf.penable),
      .paddr_i  (apb_intf.paddr),
      .pwrite_i (apb_intf.pwrite),
      .pwdata_i (apb_intf.pwdata),
      .pstrb_i  (apb_intf.pstrb),
      .pready_o (apb_intf.pready),
      .prdata_o (apb_intf.prdata),
      .pslverr_o(apb_intf.pslverr),
      .uart_tx_o(uart_intf.rx),
      .uart_rx_i(uart_intf.tx)
  );

  //////////////////////////////////////////////////////////////////////////////////////////////////
  // Procedurals
  //////////////////////////////////////////////////////////////////////////////////////////////////

  initial begin

    $dumpfile("layered_tb.vcd");
    $dumpvars(0, layered_tb);
    $timeformat(-6, 0, "us");

    apb_dvr = new();
    apb_dvr.connect_intf(apb_intf);
    apb_dvr.connect_mbx(apb_dvr_mbx);

    ctrl_intf.apply_reset();
    apb_intf.reset();
    uart_intf.reset();
    ctrl_intf.enable_clock();

    apb_dvr.run();

    repeat (10) begin
      apb_uart_apb_seq_item item;
      item = new();
      item.randomize();
      item.display();
      apb_dvr_mbx.put(item);
      while (apb_dvr_mbx.num()) begin
        @(posedge ctrl_intf.clk_i);
      end
    end

    #1us;
    $finish;

  end

endmodule
