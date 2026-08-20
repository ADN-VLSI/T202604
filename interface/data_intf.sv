////////////////////////////////////////////////////////////////////////////////////////////////////
//
// Interface: data_intf
// Description: This interface encapsulates the signals required for a standard
//              valid/ready handshake protocol. It simplifies module connections
//              by bundling the data bus and its control signals together.
//
////////////////////////////////////////////////////////////////////////////////////////////////////

interface data_intf (
    input logic arst_ni,  // Active low reset signal
    input logic clk_i     // Clock signal
);

  // --- Interface Signals ---
  // These signals form the core of the handshake protocol.
  logic [127:0] data;
  logic         valid;
  logic         ready;

  // Send transaction data.
  task automatic send_data(input logic [127:0] req_data);
    data  <= req_data;
    valid <= 1'b1;
    do begin
      @(posedge clk_i);
    end while (ready == 1'b0 && arst_ni == 1'b1);
    valid <= 1'b0;
  endtask

  // Receive transaction data.
  task automatic recv_data(output logic [127:0] rsp_data);
    ready <= 1'b1;
    do begin
      @(posedge clk_i);
    end while (valid == 1'b0 && arst_ni == 1'b1);
    rsp_data = data;
    ready <= 1'b0;
  endtask

  // Monitor transaction data.
  task automatic look_data(output logic [127:0] rsp_data);
    do begin
      @(posedge clk_i);
    end while (arst_ni !== '1 || valid !== '1 || ready !== '1);
    rsp_data = data;
  endtask


endinterface
