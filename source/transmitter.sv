module transmitter (
    // Active low asynchronous reset
    input logic arst_ni,
    // Clock input
    input logic clk_i,

    // Parity enable: 1 to include parity bit, 0 to exclude
    input logic parity_en_i,
    // Parity type: 0 for even parity, 1 for odd parity
    input logic parity_type_i,
    // Second stop bit enable: 1 to include second stop bit, 0 for single stop bit
    input logic second_stop_i,

    // 8-bit data to transmit
    input  logic [7:0] data_i,
    // Valid signal indicating data_i is ready for transmission
    input  logic       valid_i,
    // Ready signal indicating transmitter is ready to accept new data
    output logic       ready_o,

    // Transmitted serial data output
    output logic tx_o
);

    // Sajjad, Ahanaf & Dip 

endmodule
