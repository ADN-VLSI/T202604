////////////////////////////////////////////////////////////////////////////////////////////////////
//
// Module: adder_top
// Description: This module implements a pipelined adder with input and output
//              buffering. It uses FIFOs to buffer the two input operands (opa, opb)
//              and the output sum. A handshake combiner synchronizes the FIFOs
//              to ensure that an addition is only performed when both input
//              operands are available and there is space for the result.
//
////////////////////////////////////////////////////////////////////////////////////////////////////

module adder_top #(
    parameter int WIDTH            = 8,  // Bit width for operands and sum
    parameter int INPUT_FIFO_SIZE  = 4,  // Log2 of the depth for input FIFOs
    parameter int OUTPUT_FIFO_SIZE = 4   // Log2 of the depth for the output FIFO
) (
    // System Signals
    input logic arst_ni,
    input logic clk_i,

    // Operand 'A' Interface (Valid/Ready Handshake)
    input  logic [WIDTH-1:0] opa_i,
    input  logic             opa_valid_i,
    output logic             opa_ready_o,

    // Operand 'B' Interface (Valid/Ready Handshake)
    input  logic [WIDTH-1:0] opb_i,
    input  logic             opb_valid_i,
    output logic             opb_ready_o,

    // Sum Interface (Valid/Ready Handshake)
    output logic [WIDTH-1:0] sum_o,
    output logic             sum_valid_o,
    input  logic             sum_ready_i
);

  // Internal signals connecting the output of the input FIFOs to the adder core.
  logic [WIDTH-1:0] internal_opa;
  logic             internal_opa_valid;
  logic             internal_opa_ready;
  logic [WIDTH-1:0] internal_opb;
  logic             internal_opb_valid;
  logic             internal_opb_ready;

  // Internal signals connecting the adder core to the input of the output FIFO.
  logic [WIDTH-1:0] internal_sum;
  logic             internal_sum_valid;
  logic             internal_sum_ready;

  // Instantiate the input FIFO for operand 'A'.
  // This buffers incoming 'opa' values.
  fifo #(
      .WIDTH(WIDTH),
      .SIZE (INPUT_FIFO_SIZE)
  ) opa_fifo (
      // System
      .arst_ni(arst_ni),
      .clk_i  (clk_i),

      // Input side (connected to module's primary input)
      .data_in_i(opa_i),
      .data_in_valid_i(opa_valid_i),
      .data_in_ready_o(opa_ready_o),

      // Output side (connected to internal logic)
      .data_out_o(internal_opa),
      .data_out_valid_o(internal_opa_valid),
      .data_out_ready_i(internal_opa_ready)
  );

  // Instantiate the input FIFO for operand 'B'.
  // This buffers incoming 'opb' values.
  fifo #(
      .WIDTH(WIDTH),
      .SIZE (INPUT_FIFO_SIZE)
  ) opb_fifo (
      // System
      .arst_ni(arst_ni),
      .clk_i  (clk_i),

      // Input side (connected to module's primary input)
      .data_in_i(opb_i),
      .data_in_valid_i(opb_valid_i),
      .data_in_ready_o(opb_ready_o),

      // Output side (connected to internal logic)
      .data_out_o(internal_opb),
      .data_out_valid_o(internal_opb_valid),
      .data_out_ready_i(internal_opb_ready)
  );

  // Instantiate the output FIFO for the sum.
  // This buffers the result from the adder before it's sent out.
  fifo #(
      .WIDTH(WIDTH),
      .SIZE (OUTPUT_FIFO_SIZE)
  ) sum_fifo (
      // System
      .arst_ni(arst_ni),
      .clk_i  (clk_i),

      // Input side (connected to internal logic)
      .data_in_i(internal_sum),
      .data_in_valid_i(internal_sum_valid),
      .data_in_ready_o(internal_sum_ready),

      // Output side (connected to module's primary output)
      .data_out_o(sum_o),
      .data_out_valid_o(sum_valid_o),
      .data_out_ready_i(sum_ready_i)
  );

  // Instantiate the core adder logic.
  // This is a purely combinational block that performs the addition.
  adder #(
      .WIDTH(WIDTH)
  ) core_adder (
      .opa_i(internal_opa),
      .opb_i(internal_opb),
      .sum_o(internal_sum)
  );

  // Instantiate the handshake combiner.
  // This is the control logic that synchronizes the data flow.
  // It ensures that we only pop from the input FIFOs and push to the output
  // FIFO when both inputs are valid and the output is ready. This creates
  // an atomic "calculate" operation.
  handshake_combiner #(
      .NUM_TX(2),  // Two transmitters: opa_fifo and opb_fifo
      .NUM_RX(1)   // One receiver: sum_fifo
  ) u_combiner (
      // Connect the valid signals from the input FIFOs.
      .tx_valid_i({internal_opa_valid, internal_opb_valid}),
      // Drive the ready signals back to the input FIFOs.
      .tx_ready_o({internal_opa_ready, internal_opb_ready}),
      // Drive the valid signal to the output FIFO.
      .rx_valid_o(internal_sum_valid),
      // Connect the ready signal from the output FIFO.
      .rx_ready_i(internal_sum_ready)
  );

endmodule
