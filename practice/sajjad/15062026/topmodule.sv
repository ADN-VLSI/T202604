module top_apb_to_uart #(
    parameter int ADDR_WIDTH = 5,
    parameter int DATA_WIDTH = 32,
    parameter int SIZE = 8
) (
    input logic arst_ni,
    input logic clk_i,

    input logic                        psel_i,
    input logic                        penable_i,
    input logic [      ADDR_WIDTH-1:0] paddr_i,
    input logic                        pwrite_i,
    input logic [      DATA_WIDTH-1:0] pwdata_i,
    input logic [(DATA_WIDTH / 8)-1:0] pstrb_i,

    output logic                       pready_o,
    output logic [DATA_WIDTH-1:0]      prdata_o,
    output logic                       pslverr_o,

    output logic                       uart_tx_o,
    input  logic                       uart_rx_i
);

    logic mreq_o, mwe_o, mack_i;
    logic [ADDR_WIDTH-1:0] maddr_o;
    logic [DATA_WIDTH-1:0] mwdata_o;

    logic parity_enable, parity_type, second_stop_bit;
    logic [7:0] regif_tx_data, rx_fifo_data, tx_fifo_data, rx_to_fifo_data;
    logic regif_tx_valid, regif_tx_ready, rx_fifo_valid, rx_fifo_ready, tx_fifo_valid, tx_fifo_ready, rx_to_fifo_valid;
    logic [SIZE:0] regif_tx_count, rx_fifo_count;
    logic [31:0] clk_div_val;
    logic rx_clk_en, tx_clk_en;

    apb_memif #(.ADDR_WIDTH(ADDR_WIDTH), .DATA_WIDTH(DATA_WIDTH)) u_apb_memif (
        .arst_ni(arst_ni), .clk_i(clk_i),
        .psel_i(psel_i), .penable_i(penable_i), .paddr_i(paddr_i),
        .pwrite_i(pwrite_i), .pwdata_i(pwdata_i), .pstrb_i(pstrb_i),
        .pready_o(pready_o), .prdata_o(prdata_o), .pslverr_o(pslverr_o),
        .mreq_o(mreq_o), .maddr_o(maddr_o), .mwe_o(mwe_o),
        .mwdata_o(mwdata_o), .mack_i(mack_i), .mrdata_i(prdata_o), .mresp_i(1'b0)
    );

    regif u_regif (
        .arst_ni(arst_ni), .clk_i(clk_i),
        .addr_i(maddr_o), .wdata_i(mwdata_o),
        .we_i(mreq_o && mwe_o), .re_i(mreq_o && !mwe_o),
        .rdata_o(prdata_o), .error_o(mack_i),
        .reg_clk_div(clk_div_val),
        .reg_parity_en(parity_enable), .reg_parity_type(parity_type),
        .reg_second_stop_bit(second_stop_bit),
        .reg_tx_count(regif_tx_count), .reg_rx_count(rx_fifo_count),
        .reg_tx_data(regif_tx_data), .reg_tx_data_valid(regif_tx_valid),
        .reg_tx_data_ready(regif_tx_ready),
        .reg_rx_data(rx_fifo_data), .reg_rx_data_valid(rx_fifo_valid),
        .reg_rx_data_ready(rx_fifo_ready)
    );

    cdc_fifo #(.DATA_WIDTH(8), .SIZE(SIZE)) u_cdc_fifo_tx (
        .data_in_arst_ni(arst_ni), .data_in_clk_i(clk_i),
        .data_in_i(regif_tx_data), .data_in_valid_i(regif_tx_valid),
        .data_in_ready_o(regif_tx_ready), .data_in_count_o(regif_tx_count),
        .data_out_arst_ni(arst_ni), .data_out_clk_i(clk_i),
        .data_out_o(tx_fifo_data), .data_out_valid_o(tx_fifo_valid),
        .data_out_ready_i(tx_fifo_ready), .data_out_count_o()
    );

    cdc_fifo #(.DATA_WIDTH(8), .SIZE(SIZE)) u_cdc_fifo_rx (
        .data_in_arst_ni(arst_ni), .data_in_clk_i(clk_i),
        .data_in_i(rx_to_fifo_data), .data_in_valid_i(rx_to_fifo_valid),
        .data_in_ready_o(), .data_in_count_o(),
        .data_out_arst_ni(arst_ni), .data_out_clk_i(clk_i),
        .data_out_o(rx_fifo_data), .data_out_valid_o(rx_fifo_valid),
        .data_out_ready_i(rx_fifo_ready), .data_out_count_o(rx_fifo_count)
    );

    transmitter u_transmitter (
        .arst_ni(arst_ni), .clk_i(clk_i),
        .parity_en_i(parity_enable), .parity_type_i(parity_type),
        .second_stop_i(second_stop_bit),
        .data_i(tx_fifo_data), .valid_i(tx_fifo_valid),
        .ready_o(tx_fifo_ready), .tx_o(uart_tx_o)
    );

    receiver u_receiver (
        .arst_ni(arst_ni), .clk_i(clk_i),
        .parity_en_i(parity_enable), .parity_type_i(parity_type),
        .second_stop_i(second_stop_bit),
        .data_o(rx_to_fifo_data), .valid_o(rx_to_fifo_valid),
        .rx_i(uart_rx_i)
    );

    clk_freq_div #(.DIV_WIDTH(32)) u_rx_clk_div (
        .arst_ni(arst_ni), .clk_i(clk_i),
        .div_i(clk_div_val), .en_o(rx_clk_en)
    );