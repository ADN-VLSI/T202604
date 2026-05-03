module memory #(
    parameter int ADDR_WIDTH = 10,
    parameter int DATA_WIDTH = 32
) (
    // Global signals
    input logic clk_i,  // Clock input

    // Memory Interface inputs
    input logic                           mreq_i,    // Memory request
    input logic [    ADDR_WIDTH-1:0]      maddr_i,   // Memory address
    input logic                           mwe_i,     // Memory write enable
    input logic [(DATA_WIDTH/8)-1:0][7:0] mwdata_i,  // Memory write data
    input logic [(DATA_WIDTH/8)-1:0]      mstrb_i,   // Memory byte strobe

    // Memory Interface outputs
    output logic                           mack_o,    // Memory acknowledge
    output logic [(DATA_WIDTH/8)-1:0][7:0] mrdata_o,  // Memory read data
    output logic                           mresp_o    // Memory response
);

  logic [7:0] mem[2**ADDR_WIDTH];

  always_comb mack_o = mreq_i;  // Acknowledge immediately for simplicity
  always_comb mresp_o = '0;  // No error response for simplicity

  // always read memory
  always_comb begin
    foreach (mrdata_o[i]) begin
      mrdata_o[i] = mem[maddr_i+i];
    end
  end

  always_ff @(posedge clk_i) begin
    if (mreq_i && mwe_i) begin
      foreach (mwdata_i[i]) begin
        if (mstrb_i[i]) begin
          mem[maddr_i+i] <= mwdata_i[i];
        end
      end
    end
  end

endmodule
