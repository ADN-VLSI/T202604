module layered_tb;

  `include "lt/apb_uart_apb_dvr.sv"
  `include "lt/apb_uart_apb_mon.sv"
  `include "lt/apb_uart_uart_dvr.sv"
  `include "lt/apb_uart_uart_mon.sv"

  `include "lt/apb_uart_scbd.sv"
  `include "lt/uart_cfg.sv"

  `include "lt/apb_uart_apb_seq_item.sv"
  `include "lt/apb_uart_apb_rsp_item.sv"
  `include "lt/apb_uart_uart_seq_item.sv"
  `include "lt/apb_uart_uart_rsp_item.sv"

  //////////////////////////////////////////////////////////////////////////////////////////////////
  // Parameters
  //////////////////////////////////////////////////////////////////////////////////////////////////

  import uart_pkg::ADDR_WIDTH;
  import uart_pkg::DATA_WIDTH;

  // UART Register Map
  import uart_pkg::UART_CTRL_OFFSET;
  import uart_pkg::UART_CFG_OFFSET;
  import uart_pkg::UART_STAT_OFFSET;
  import uart_pkg::UART_TX_DATA_OFFSET;
  import uart_pkg::UART_RX_DATA_OFFSET;

  import uart_pkg::ZEROS;
  import uart_pkg::UART_EN_IDX;
  import uart_pkg::TX_FLUSH_IDX;
  import uart_pkg::RX_FLUSH_IDX;

  import uart_pkg::CLK_DIV_IDX;
  import uart_pkg::PARITY_EN_IDX;
  import uart_pkg::PARITY_TYPE_IDX;
  import uart_pkg::SECOND_STOP_BIT_IDX;

  //////////////////////////////////////////////////////////////////////////////////////////////////
  // Variables
  //////////////////////////////////////////////////////////////////////////////////////////////////

  string testname;
  int testlength;

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

  mailbox #(apb_uart_apb_seq_item) apb_dvr_mbx;
  mailbox #(apb_uart_apb_rsp_item) apb_mon_mbx;

  mailbox #(apb_uart_uart_seq_item) uart_dvr_mbx;
  mailbox #(apb_uart_uart_rsp_item) uart_mon_mbx;

  mailbox #(uart_cfg) uart_cfg_mbx;

  apb_uart_apb_dvr apb_dvr;
  apb_uart_apb_mon apb_mon;

  apb_uart_uart_dvr uart_dvr;
  apb_uart_uart_mon uart_mon;

  apb_uart_scbd    scbd;

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
  // Methods
  //////////////////////////////////////////////////////////////////////////////////////////////////

  task automatic random_apb_sequence(input int tl = 10);
    repeat (tl) begin
      apb_uart_apb_seq_item item;
      item = new();
      item.randomize();
      apb_dvr_mbx.put(item);
    end
  endtask

  task automatic apb_write(input bit [4:0] _addr_, input bit [31:0] _data_);
    apb_uart_apb_seq_item item;
    item = new();
    item.randomize() with {item.write == 1'b1; item.addr == _addr_; item.data == _data_;};
    apb_dvr_mbx.put(item);
  endtask

  task automatic apb_read(input bit [4:0] _addr_);
    apb_uart_apb_seq_item item;
    item = new();
    item.randomize() with {item.write == 1'b0; item.addr == _addr_;};
    apb_dvr_mbx.put(item);
  endtask

  task automatic uart_init_sequence(input int baud = 9600, input bit pen = 0, input bit pty = 0,
                                    input bit sstop = 0);
    int clk_div;
    clk_div = 100_000_000 / baud;
    clk_div = clk_div & 'b0000_1111_1111_1111;
    apb_write(UART_CTRL_OFFSET, TX_FLUSH_IDX | RX_FLUSH_IDX);
    apb_write(UART_CTRL_OFFSET, ZEROS);
    apb_write(UART_CFG_OFFSET,
              (clk_div << CLK_DIV_IDX) | (pen << PARITY_EN_IDX) | (pty << PARITY_TYPE_IDX) | (sstop << SECOND_STOP_BIT_IDX));
    apb_write(UART_CTRL_OFFSET, UART_EN_IDX);
  endtask

  task automatic uart_write_data(input bit [7:0] data);
    apb_write(UART_TX_DATA_OFFSET, data);
  endtask

  task automatic uart_write_string(input string txt = "Hello!\n");
    for (int i = 0; i < txt.len(); i++) begin
      uart_write_data(txt[i]);
    end
  endtask

  //////////////////////////////////////////////////////////////////////////////////////////////////
  // Procedurals
  //////////////////////////////////////////////////////////////////////////////////////////////////

  initial begin

    ///////////////////////////////////////////////////////////////////////////
    // INIT PHASE
    ///////////////////////////////////////////////////////////////////////////

    $dumpfile("layered_tb.vcd");
    $dumpvars(0, layered_tb);
    $timeformat(-6, 0, "us");

    if (!$value$plusargs("TEST_NAME=%s", testname)) begin
      $fatal(1, "ERROR: testname argument is required");
    end

    if (!$value$plusargs("TEST_LEN=%d", testlength)) begin
      testlength = 10;
    end

    ///////////////////////////////////////////////////////////////////////////
    // BUILD PHASE
    ///////////////////////////////////////////////////////////////////////////

    apb_dvr = new();
    apb_mon = new();

    uart_dvr = new();
    uart_mon = new();

    scbd    = new();

    apb_dvr_mbx = new(1);
    apb_mon_mbx = new();
    uart_cfg_mbx = new();
    uart_dvr_mbx = new(1);
    uart_mon_mbx = new();

    ///////////////////////////////////////////////////////////////////////////
    // CONNECT PHASE
    ///////////////////////////////////////////////////////////////////////////

    apb_dvr.connect_intf(apb_intf);
    apb_mon.connect_intf(apb_intf);
    uart_dvr.connect_intf(uart_intf);
    uart_mon.connect_intf(uart_intf);

    apb_dvr.connect_mbx(apb_dvr_mbx);
    apb_mon.connect_mbx(apb_mon_mbx);
    uart_dvr.connect_mbx(uart_dvr_mbx);
    uart_mon.connect_mbx(uart_mon_mbx);

    scbd.connect_apb_mbx(apb_mon_mbx);
    scbd.connect_uart_mbx(uart_mon_mbx);

    scbd.connect_uart_cfg_mbx(uart_cfg_mbx);

    ///////////////////////////////////////////////////////////////////////////
    // RUN PHASE : RESET
    ///////////////////////////////////////////////////////////////////////////

    // Reset and enable clock
    ctrl_intf.apply_reset();
    apb_intf.reset();
    uart_intf.reset();
    ctrl_intf.enable_clock();

    // Enable the APB driver and monitor
    apb_dvr.run();
    apb_mon.run();
    uart_dvr.run();
    uart_mon.run();
    scbd.run();

    fork
      uart_cfg cfg;
      forever begin
        uart_cfg_mbx.get(cfg);
        uart_intf.BAUD_RATE = cfg.BAUD_RATE;
        uart_intf.PARITY_ENABLE = cfg.PARITY_ENABLE;
        uart_intf.PARITY_TYPE = cfg.PARITY_TYPE;
        uart_intf.SECOND_STOP_BIT = cfg.SECOND_STOP_BIT;
        uart_intf.DATA_BITS = cfg.DATA_BITS;
        $display(
            "UART RECONFIGURED AT: BAUD_RATE=%0d, PARITY_ENABLE=%0d, PARITY_TYPE=%0d, SECOND_STOP_BIT=%0d, DATA_BITS=%0d",
            uart_intf.BAUD_RATE, uart_intf.PARITY_ENABLE, uart_intf.PARITY_TYPE,
            uart_intf.SECOND_STOP_BIT, uart_intf.DATA_BITS);
      end
    join_none

    ///////////////////////////////////////////////////////////////////////////
    // RUN PHASE : CONFIGURE
    ///////////////////////////////////////////////////////////////////////////

    // Configure the UART with desired settings (baud rate, no parity, even parity, no second stop bit)
    uart_init_sequence(115200, 0, 0, 0);
    apb_intf.wait_till_idle();

    ///////////////////////////////////////////////////////////////////////////
    // RUN PHASE : MAIN
    ///////////////////////////////////////////////////////////////////////////

    $display("Running test: %s, length: %0d", testname, testlength);

    case (testname)

      "random_apb": begin
        random_apb_sequence(testlength);
      end

      "write": begin
        repeat (testlength) uart_write_data($urandom_range('h41, 'h5a));
      end

      "hello": begin
        uart_write_string("Hello World!\n");
      end

      default: begin
        $fatal(1, "ERROR: Unknown testname %s", testname);
      end

    endcase

    ///////////////////////////////////////////////////////////////////////////
    // RUN PHASE : SHUTDOWN
    ///////////////////////////////////////////////////////////////////////////

    apb_intf.wait_till_idle();
    uart_intf.wait_till_idle();

    ///////////////////////////////////////////////////////////////////////////
    // REPORT PHASE
    ///////////////////////////////////////////////////////////////////////////

    scbd.report();

    #1us;
    $finish;

  end

endmodule
