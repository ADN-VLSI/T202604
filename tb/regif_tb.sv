module regif_tb;

  // --- Clock and Reset Signals ---
  logic        clk_i;
  logic        arst_ni;

  // --- APB-like Interface Signals ---
  logic [2:0]  addr_i;
  logic [31:0] wdata_i;
  logic        we_i;
  logic        re_i;
  logic [31:0] rdata_o;
  logic        error_o;

  // --- Control & Config Outputs ---
  logic        reg_uart_en;
  logic        reg_tx_flush;
  logic        reg_rx_flush;
  logic [11:0] reg_clk_div;
  logic        reg_parity_en;
  logic        reg_parity_type;
  logic        reg_second_stop_bit;

  // --- Status Inputs ---
  logic [9:0]  reg_tx_count;
  logic [9:0]  reg_rx_count;

  // --- TX/RX Handshake Signals ---
  logic [7:0]  reg_tx_data;
  logic        reg_tx_data_valid;
  logic        reg_tx_data_ready;

  logic [7:0]  reg_rx_data;
  logic        reg_rx_data_valid;
  logic        reg_rx_data_ready;

  // --- Offset Definition (As in package) ---
  localparam [2:0] UART_CTRL_OFFSET    = 3'b000;
  localparam [2:0] UART_CFG_OFFSET     = 3'b001;
  localparam [2:0] UART_STAT_OFFSET    = 3'b010;
  localparam [2:0] UART_TX_DATA_OFFSET = 3'b011;
  localparam [2:0] UART_RX_DATA_OFFSET = 3'b100;

  // --- Device Under Test (DUT) Instantiation ---
  regif dut (
    .clk_i               (clk_i),
    .arst_ni             (arst_ni),
    .addr_i              (addr_i),
    .wdata_i             (wdata_i),
    .we_i                (we_i),
    .re_i                (re_i),
    .rdata_o             (rdata_o),
    .error_o             (error_o),
    .reg_uart_en         (reg_uart_en),
    .reg_tx_flush        (reg_tx_flush),
    .reg_rx_flush        (reg_rx_flush),
    .reg_clk_div         (reg_clk_div),
    .reg_parity_en       (reg_parity_en),
    .reg_parity_type     (reg_parity_type),
    .reg_second_stop_bit (reg_second_stop_bit),
    .reg_tx_count        (reg_tx_count),
    .reg_rx_count        (reg_rx_count),
    .reg_tx_data         (reg_tx_data),
    .reg_tx_data_valid   (reg_tx_data_valid),
    .reg_tx_data_ready   (reg_tx_data_ready),
    .reg_rx_data         (reg_rx_data),
    .reg_rx_data_valid   (reg_rx_data_valid),
    .reg_rx_data_ready   (reg_rx_data_ready)
  );

  // --- Clock Generation (100 MHz) ---
  always #5 clk_i = ~clk_i;

  // --- Helper Tasks for Verification ---
  
  // Task for Register Write Operation
  task write_reg(input logic [2:0] addr, input logic [31:0] data);
    begin
      @(posedge clk_i);
      addr_i  = addr;
      wdata_i = data;
      we_i    = 1'b1;
      re_i    = 1'b0;
      @(posedge clk_i);
      #1; // small delay to check outputs safely
      we_i    = 1'b0;
    end
  endtask

  // Task for Register Read Operation
  task read_reg(input logic [2:0] addr);
    begin
      @(posedge clk_i);
      addr_i  = addr;
      we_i    = 1'b0;
      re_i    = 1'b1;
      @(posedge clk_i);
      #1;
      re_i    = 1'b0;
    end
  endtask

  // --- Main Test Stimulus ---
  initial begin
    // Initialize Inputs
    clk_i             = 0;
    arst_ni           = 0;
    addr_i            = 0;
    wdata_i           = 0;
    we_i              = 0;
    re_i              = 0;
    reg_tx_count      = 0;
    reg_rx_count      = 0;
    reg_tx_data_ready = 0;
    reg_rx_data       = 0;
    reg_rx_data_valid = 0;

    // 1. Reset Release
    #20;
    arst_ni = 1'b1;
    $display("[TB] Reset Released.");

    // 2. Test Control Register (UART_CTRL) Write & Read
    $display("\n--- Testing Control Register ---");
    write_reg(UART_CTRL_OFFSET, 3'b101); // UART Enable = 1, TX Flush = 0, RX Flush = 1
    read_reg(UART_CTRL_OFFSET);
    $display("Read CTRL Data: %b (Expected: 101)", rdata_o[2:0]);

    // 3. Test Configuration Register (UART_CFG) Write & Read
    $display("\n--- Testing Configuration Register ---");
    // Clock Div = 12'd50, Parity En = 1, Parity Type = 0, 2nd Stop Bit = 1
    // Concatenation logic format: {stop_bit, parity_type, parity_en, clk_div}
    write_reg(UART_CFG_OFFSET, {1'b1, 1'b0, 1'b1, 12'd50}); 
    read_reg(UART_CFG_OFFSET);
    $display("Read CFG Data: %b (Expected: 101000000110010)", rdata_o[14:0]);

    // 4. Test Status Register Read (UART_STAT)
    $display("\n--- Testing Status Register ---");
    reg_tx_count = 10'd15;
    reg_rx_count = 10'd8;
    read_reg(UART_STAT_OFFSET);
    $display("Read STAT Data: TX Count = %d, RX Count = %d", rdata_o[9:0], rdata_o[19:10]);

    // 5. Test TX Data Path & Ready-Valid Handshake Error
    $display("\n--- Testing TX Data Path ---");
    reg_tx_data_ready = 1'b0; // TX FIFO full / not ready
    write_reg(UART_TX_DATA_OFFSET, 32'hAA);
    $display("TX Not Ready: error_o = %b (Expected: 1), TX Valid = %b", error_o, reg_tx_data_valid);

    reg_tx_data_ready = 1'b1; // TX FIFO ready now
    write_reg(UART_TX_DATA_OFFSET, 32'h55);
    $display("TX Ready: error_o = %b (Expected: 0), TX Valid = %b, Data = %h", error_o, reg_tx_data_valid, reg_tx_data);

    // 6. Test RX Data Path & Read Error
    $display("\n--- Testing RX Data Path ---"); 
    reg_rx_data_valid = 1'b0; // No data in RX FIFO
    read_reg(UART_RX_DATA_OFFSET);
    $display("RX Data Invalid Read: error_o = %b (Expected: 1)", error_o);

    reg_rx_data       = 8'hE9;
    reg_rx_data_valid = 1'b1; // Data available
    read_reg(UART_RX_DATA_OFFSET);
    $display("RX Data Valid Read: error_o = %b (Expected: 0), Read Data = %h", error_o, rdata_o[7:0]);

    // 7. Test simultaneous Write and Read Error
    $display("\n--- Testing Simultaneous WE and RE Error ---");
    @(posedge clk_i);
    we_i = 1'b1;
    re_i = 1'b1;
    #1;
    $display("Simultaneous Read/Write: error_o = %b (Expected: 1)", error_o);
    
    // Finish Simulation
    #50;
    $display("\n[TB] Simulation Completed successfully.");
    $finish;
  end

endmodule