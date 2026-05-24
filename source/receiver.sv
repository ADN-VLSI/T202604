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
    logic [7:0] rx_data_shift;  // Shift register for incoming data bits
    logic starting_edge_detected;  // Flag to indicate detection of start bit
    logic parity_checked;
    logic paritydata;
    logic rx_q;


    assign data_o = rx_data_shift;  // Output the received data
    assign paritydata = ^rx_data_shift;  // Calculate parity from received data bits


    always_ff @(posedge clk_i or negedge arst_ni) begin
    if (!arst_ni) begin
      rx_q <= 1'b1;  // Idle line is high
    end else begin
      rx_q <= rx_i;
    end
  end

    always_ff @(posedge clk_i or negedge arst_ni) begin
        if (!arst_ni) begin
            starting_edge_detected <= 1'b0;  // Clear start bit detection on reset
        end else begin
            // Detect falling edge for start bit (rx_i goes from high to low)
           starting_edge_detected <= (rx_i == 1'b0) && (rx_q == 1'b1); // NEED FSM?
                
            end
        end
    

    always_ff @(posedge clk_i or negedge arst_ni) begin
        if (!arst_ni) begin
            rx_data_shift <= 8'b0;  // Reset shift register on reset
                    // Clear valid signal on reset
        end else begin
           if (starting_edge_detected) begin // start bit detection FSM??
               // Shift in the received bit into the appropriate position 
               rx_data_shift [0] <= rx_i;
               rx_data_shift [1] <= rx_i;
               rx_data_shift [2] <= rx_i;
               rx_data_shift [3] <= rx_i;
               rx_data_shift [4] <= rx_i;
               rx_data_shift [5] <= rx_i;
               rx_data_shift [6] <= rx_i;
               rx_data_shift [7] <= rx_i;  // Example shift operation
           end              
        end
    end 

     always_ff @(posedge clk_i or negedge arst_ni) begin
        if (!arst_ni) begin
            parity_checked <= 1'b0;  // Clear parity check on reset
        end else begin
            if (parity_en_i && starting_edge_detected && rx_i) begin
                // Perform parity check based on parity_type_i
                // This is a placeholder for actual parity checking logic
                parity_checked <= parity_type_i ? (rx_i == ~paritydata) : (rx_i == paritydata); // Example parity check
            end else begin
                parity_checked <= 1'b0;  // No parity check if not enabled
            end
        end
    end

endmodule
