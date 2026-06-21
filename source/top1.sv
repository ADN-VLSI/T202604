`include "package/uart_pkg.sv"

module apb_uart_top #(
    parameter int ADDR_WIDTH = 32,
    parameter int DATA_WIDTH = 32,
    parameter int FIFO_SIZE  = 4
) (
    // =============================================================================================
    // Global Clock and Reset Signals (True Single-Clock Synchronous Architecture)
    // =============================================================================================
    input logic pclk_i,           // Main System Clock (APB Bus Clock, e.g., 300 MHz)
    input logic prst_ni,          // Global Reset, Active Low

    // =============================================================================================
    // APB Slave Interface Ports
    // =============================================================================================
    input  logic                         psel_i,
    input  logic                         penable_i,
    input  logic [  ADDR_WIDTH-1:0]      paddr_i,
    input  logic                         pwrite_i,
    input  logic [  DATA_WIDTH-1:0]      pwdata_i,
    input  logic [(DATA_WIDTH / 8)-1:0]  pstrb_i,

    output logic                         pready_o,
    output logic [DATA_WIDTH-1:0]        prdata_o,
    output logic                         pslverr_o,

    // =============================================================================================
    // UART Serial Interface Pins (Actual Hardware Pins)
    // =============================================================================================
    output logic                         tx_o,                 // Serial Data Output Pin
    input  logic                         rx_i                  // Serial Data Input Pin
);

    // =============================================================================================
    // Internal Signal Wires
    // =============================================================================================
    // Interconnect wires between APB-MEMIF and REG-IF
    logic                  internal_mreq;
    logic [ADDR_WIDTH-1:0] internal_maddr;
    logic                  internal_mwe; 
    logic [DATA_WIDTH-1:0] internal_mwdata;
    logic [DATA_WIDTH-1:0] internal_mrdata;
    
    logic                  internal_mack;
    logic                  internal_mresp;

    logic                  internal_we; //    mreq & mwe
    logic                  internal_re; //      mreq & ~mwe

    // Configuration control wires from REG-IF to other sub-modules
    logic                  reg_uart_en;
    logic                  reg_parity_en;
    logic                  reg_parity_type;
    logic                  reg_second_stop_bit;
    logic [11:0]           reg_clk_div;
    logic [ 9:0]           reg_tx_count;
    logic [ 9:0]           reg_rx_count;
    logic                  reg_tx_flush;
    logic                  reg_rx_flush;

    // Parallel Data interface wires between REG-IF and FIFOs (APB Domain)
    logic [ 7:0]           reg_tx_data;
    logic                  reg_tx_data_valid;
    logic                  reg_tx_data_ready;

    logic [ 7:0]           reg_rx_data;
    logic                  reg_rx_data_valid;
    logic                  reg_rx_data_ready;

    // Data wires from TX FIFO to Transmitter Module
    logic [ 7:0]           tx_fifo_data;
    logic                  tx_fifo_valid;
    logic                  tx_fifo_ready;
    logic                  qualified_tx_valid;

    // Data wires from Receiver Module to RX FIFO
    logic [ 7:0]           rx_uart_data;
    logic                  rx_uart_valid;
    logic                  rx_fifo_ready;
    logic                  qualified_rx_valid;
    
    // Internal Generated Clock Enable Pulses (Clean Synchronous Ticks)
    logic                  baud_x8_tick;    // 8x Over-sampling Tick for Receiver
    logic                  baud_x1_tick;    // 1x Base Baud Rate Tick for Transmitter
    logic [ 2:0]           tx_tick_divider; // 3-bit counter to divide 8x down to 1x

    // =============================================================================================
    // APB to REG-IF Bridge / Handshake Glue Logic
    // =============================================================================================
    assign internal_we = internal_mreq & internal_mwe;
    assign internal_re = internal_mreq & ~internal_mwe;

    always_ff @(posedge pclk_i or negedge prst_ni) begin
        if (~prst_ni) internal_mack <= 1'b0;
        else          internal_mack <= internal_mreq & ~internal_mack;
    end

    // =============================================================================================
    // Baud Rate Generator (Clean Synchronous Pulse Division)
    // =============================================================================================
    // Generates a clean 1-cycle enable tick that triggers at 8x of the required baud rate
    clk_freq_div #(
        .DIV_WIDTH (12)
    ) u_clk_div (
        .clk_i   (clk_i),
        .arst_ni (arst_ni),
        .div_i   (reg_clk_div),
        .en_o    (baud_x8_tick) 
    );

    // Synchronous divider to generate 1x base baud rate tick from 8x tick
    always_ff @(posedge pclk_i or negedge prst_ni) begin
        if (~prst_ni) begin
            tx_tick_divider <= 3'b0;
            baud_x1_tick    <= 1'b0;
        end 
        else begin
            baud_x1_tick <= 1'b0; // Default low
            if (baud_x8_tick) begin
                tx_tick_divider <= tx_tick_divider + 1'b1;
                if (tx_tick_divider == 3'd7) begin
                    baud_x1_tick <= 1'b1; // High exactly once every 8 pulses of baud_x8_tick
                end
            end
        end
    end

    // =============================================================================================
    // 1. APB Memory Interface Module Instance
    // =============================================================================================
    apb_memif #(
        .ADDR_WIDTH (ADDR_WIDTH),
        .DATA_WIDTH (DATA_WIDTH)
    ) u_apb_memif (
        .clk_i     (pclk_i),
        .arst_ni   (prst_ni),
        .psel_i    (psel_i),
        .penable_i (penable_i),
        .paddr_i   (paddr_i),
        .pwrite_i  (pwrite_i),
        .pwdata_i  (pwdata_i),
        .pstrb_i   (pstrb_i),
        .pready_o  (pready_o),
        .prdata_o  (prdata_o),
        .pslverr_o (pslverr_o),


        .mreq_o    (internal_mreq),
        .maddr_o   (internal_maddr),
        .mwe_o     (internal_mwe),
        .mwdata_o  (internal_mwdata),
        .mstrb_o   (), 
        .mack_i    (internal_mack),
        .mrdata_i  (internal_mrdata),
        .mresp_i   (internal_mresp)
    );

    // =============================================================================================
    // 2. Register Interface Module Instance
    // =============================================================================================
    regif u_regif (
        .clk_i               (pclk_i),
        .arst_ni             (prst_ni),
        
        .addr_i              (internal_maddr[2:0]),
        .wdata_i             (internal_mwdata),
        .we_i                (internal_we),
        .re_i                (internal_re),
        .rdata_o             (internal_mrdata),
        .error_o             (internal_mresp),
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

    // =============================================================================================
    // 3. FIFO Module Instance (TX Path)
    // =============================================================================================
    cdc_fifo #(
        .DATA_WIDTH (8),
        .SIZE       (FIFO_SIZE)
    ) u_cdc_fifo_tx (
        .data_in_clk_i    (pclk_i),
        .data_in_arst_ni  (prst_ni),
        .data_in_i        (reg_tx_data), 
        .data_in_valid_i  (reg_tx_data_valid),
        .data_in_ready_o  (reg_tx_data_ready),
        .data_in_count_o  (reg_tx_count),

        // Running on safe global clock domain
        .data_out_clk_i   (pclk_i), 
        .data_out_arst_ni (prst_ni),
        .data_out_o       (tx_fifo_data),
        .data_out_valid_o (tx_fifo_valid),
        .data_out_ready_i (tx_fifo_ready & baud_x1_tick), // Popped exactly at 1x baud interval
        .data_out_count_o ()
    );

    // Handshake gating logic for transmitter sequence control
    assign qualified_tx_valid = tx_fifo_valid & baud_x1_tick;

    // =============================================================================================
    // 4. FIFO Module Instance (RX Path)
    // =============================================================================================
    cdc_fifo #(
        .DATA_WIDTH (8),
        .SIZE       (FIFO_SIZE)
    ) u_cdc_fifo_rx (
        // Running on safe global clock domain
        .data_in_clk_i    (pclk_i), 
        .data_in_arst_ni  (prst_ni),
        .data_in_i        (rx_uart_data), 
        .data_in_valid_i  (qualified_rx_valid), // Pushed only when receiver captures a complete byte
        .data_in_ready_o  (rx_fifo_ready),
        .data_in_count_o  (),

        .data_out_clk_i   (pclk_i),
        .data_out_arst_ni (prst_ni),
        .data_out_o       (reg_rx_data),
        .data_out_valid_o (reg_rx_data_valid),
        .data_out_ready_i (reg_rx_data_ready),
        .data_out_count_o (reg_rx_count)
    );

    // Pushes valid data to FIFO only when the receiver finishes a byte exactly at 8x execution tick
    assign qualified_rx_valid = rx_uart_valid & baud_x8_tick;

    // =============================================================================================
    // 5. UART Transmitter Instance (1x Base Baud Control via Qualified Handshake)
    // =============================================================================================
    transmitter u_transmitter (
        .clk_i         (pclk_i),       // Connected to true system clock for stable setup/hold times
        .arst_ni       (prst_ni),
        .parity_en_i   (reg_parity_en),
        .parity_type_i (reg_parity_type),
        .second_stop_i (reg_second_stop_bit),
        .data_i        (tx_fifo_data),
        .valid_i       (qualified_tx_valid), // Steps state machine only when baud tick triggers
        .ready_o       (tx_fifo_ready), 
        .tx_o          (tx_o)           
    );

    // =============================================================================================
    // 6. UART Receiver Instance (8x Over-sampling Control via Stream Sampling)
    // =============================================================================================
    receiver #(
        .clktick_per_bit(8)        
    ) u_receiver (
        .clk_i         (pclk_i),       // Connected to true system clock for stable setup/hold times
        .arst_ni       (prst_ni),
        .parity_en_i   (reg_parity_en),
        .parity_type_i (reg_parity_type),
        .second_stop_i (reg_second_stop_bit),
        .data_o        (rx_uart_data),
        .valid_o       (rx_uart_valid),
        .rx_i          (rx_i)          // Clean, un-gated physical input stream
    );

endmodule