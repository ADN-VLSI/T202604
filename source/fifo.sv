////////////////////////////////////////////////////////////////////////////////////////////////////
//
// Module: fifo
// Description: A synchronous First-In, First-Out (FIFO) buffer with
//              asynchronous active-low reset. It uses a standard
//              valid/ready handshake protocol for input and output.
//
////////////////////////////////////////////////////////////////////////////////////////////////////

module fifo #(
    parameter WIDTH = 8,  // Width of the data bus
    parameter SIZE  = 3   // Log2 of the FIFO depth. Depth = 2**SIZE
) (
    // System Signals
    input logic arst_ni,  // Asynchronous reset, active low
    input logic clk_i,    // Clock

    // Input Handshake Interface
    input  logic [WIDTH-1:0] data_in_i,        // Data to be written into the FIFO
    input  logic             data_in_valid_i,  // Indicates data_in_i is valid
    output logic             data_in_ready_o,  // Indicates FIFO is ready to accept data

    // Output Handshake Interface
    output logic [WIDTH-1:0] data_out_o,        // Data read from the FIFO
    output logic             data_out_valid_o,  // Indicates data_out_o is valid
    input  logic             data_out_ready_i   // Indicates consumer is ready for data
);

  // FIFO memory array
  logic [WIDTH-1:0] mem[2**SIZE];

  // Pointers to track write and read locations.
  // They are one bit wider than needed to index the memory to distinguish
  // between full and empty conditions. The MSB acts as a wrap-around counter.
  logic [SIZE:0] wr_ptr;
  logic [SIZE:0] rd_ptr;

  // Handshake signals for write and read operations
  logic ip_handshake;
  logic op_handshake;

  // A write occurs when input data is valid and the FIFO is ready.
  assign ip_handshake = data_in_valid_i && data_in_ready_o;
  // A read occurs when output data is valid and the consumer is ready.
  assign op_handshake = data_out_ready_i && data_out_valid_o;

  // Combinational read from the FIFO memory.
  assign data_out_o = mem[rd_ptr[SIZE-1:0]];

  // FIFO is not empty if the write and read pointers are different.
  assign data_out_valid_o = !(wr_ptr == rd_ptr);
  // FIFO is full if the MSBs of the pointers differ, but the lower bits are the same.
  // This indicates the write pointer has wrapped around and caught up to the read pointer.
  assign data_in_ready_o = !((wr_ptr[SIZE] != rd_ptr[SIZE]) && (wr_ptr[SIZE-1:0] == rd_ptr[SIZE-1:0]));

  // Sequential logic for pointer updates and memory writes.
  always_ff @(posedge clk_i or negedge arst_ni) begin
    if (!arst_ni) begin
      // On reset, clear both pointers, making the FIFO empty.
      wr_ptr <= 0;
      rd_ptr <= 0;
    end else begin
      // On a write transaction, store the data and increment the write pointer.
      if (ip_handshake) begin
        mem[wr_ptr[SIZE-1:0]] <= data_in_i;
        wr_ptr <= wr_ptr + 1;
      end

      // On a read transaction, increment the read pointer.
      if (op_handshake) begin
        rd_ptr <= rd_ptr + 1;
      end
    end
  end

endmodule
