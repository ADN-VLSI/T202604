module receiver (
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

    // 8-bit data to receive
    output logic [7:0] data_o,
    // Valid signal indicating data_o is ready for reception
    output logic       valid_o,

    // Received serial data input
    input logic rx_i
);

    // Tusha

endmodule
