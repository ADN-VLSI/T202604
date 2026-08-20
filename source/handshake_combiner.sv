////////////////////////////////////////////////////////////////////////////////////////////////////
//
// Module: handshake_combiner
// Description: This module synchronizes multiple valid/ready handshake pairs.
//              It acts as a central point that allows a transaction to proceed
//              only when ALL transmitters are valid and ALL receivers are ready.
//              This ensures an atomic, all-or-nothing transaction across
//              multiple interfaces.
//
////////////////////////////////////////////////////////////////////////////////////////////////////

module handshake_combiner #(
    parameter int NUM_TX = 2,  // Number of transmitter (input) interfaces
    parameter int NUM_RX = 2   // Number of receiver (output) interfaces
) (
    // Transmitter side interface
    input  logic [NUM_TX-1:0] tx_valid_i,  // Array of valid signals from each transmitter
    output logic [NUM_TX-1:0] tx_ready_o,  // Array of ready signals to each transmitter

    // Receiver side interface
    output logic [NUM_RX-1:0] rx_valid_o,  // Array of valid signals to each receiver
    input  logic [NUM_RX-1:0] rx_ready_i   // Array of ready signals from each receiver
);

  // Internal signal that is high only when all handshakes can proceed.
  logic all_handshakes_ok;

  // Combinational logic to determine the state of all handshakes.
  always_comb begin
    logic all_tx_valid;
    logic all_rx_ready;

    // Check if all transmitters are indicating valid data.
    // The reduction AND operator (&) returns '1' if all bits in the vector are '1'.
    all_tx_valid = &tx_valid_i;
    // Check if all receivers are ready to accept data.
    all_rx_ready = &rx_ready_i;

    // The overall transaction is a go only if all transmitters are valid AND all receivers are ready.
    all_handshakes_ok = all_tx_valid & all_rx_ready;

    // All transmitters are signaled 'ready' simultaneously based on the overall status.
    tx_ready_o = {NUM_TX{all_handshakes_ok}};
    // All receivers are signaled 'valid' simultaneously based on the overall status.
    rx_valid_o = {NUM_RX{all_handshakes_ok}};
  end

endmodule
