module apb_uart_top_tb;

  localparam int ADDR_WIDTH = 5;
  localparam int DATA_WIDTH = 32;
  localparam int SIZE       = 8;

  logic arst_ni;
  logic clk_i;

  logic                    psel_i;
  logic                    penable_i;
  logic [ADDR_WIDTH-1:0]   paddr_i;
  logic                    pwrite_i;
  logic [DATA_WIDTH-1:0]   pwdata_i;
  logic [DATA_WIDTH/8-1:0] pstrb_i;

  logic                    pready_o;
  logic [DATA_WIDTH-1:0]   prdata_o;
  logic                    pslverr_o;

  logic uart_tx_o;
  logic uart_rx_i;

  apb_uart_top #(
      .ADDR_WIDTH(ADDR_WIDTH),
      .DATA_WIDTH(DATA_WIDTH),
      .SIZE(SIZE)
  ) dut (
      .arst_ni(arst_ni),
      .clk_i(clk_i),
      .psel_i(psel_i),
      .penable_i(penable_i),
      .paddr_i(paddr_i),
      .pwrite_i(pwrite_i),
      .pwdata_i(pwdata_i),
      .pstrb_i(pstrb_i),
      .pready_o(pready_o),
      .prdata_o(prdata_o),
      .pslverr_o(pslverr_o),
      .uart_tx_o(uart_tx_o),
      .uart_rx_i(uart_rx_i)
  );

  initial begin
    clk_i = 0;
    forever #5 clk_i = ~clk_i;
  end

  task automatic apb_write(
      input logic [ADDR_WIDTH-1:0] addr,
      input logic [DATA_WIDTH-1:0] data
  );
  begin
    @(posedge clk_i);
    psel_i    <= 1'b1;
    penable_i <= 1'b0;
    pwrite_i  <= 1'b1;
    paddr_i   <= addr;
    pwdata_i  <= data;
    pstrb_i   <= '1;

    @(posedge clk_i);
    penable_i <= 1'b1;

    wait(pready_o); 

    @(posedge clk_i);
    psel_i    <= 0;
    penable_i <= 0;
    pwrite_i  <= 0;
    pstrb_i   <= 0;
  end
  endtask

  task automatic apb_read(
      input  logic [ADDR_WIDTH-1:0] addr,
      output logic [DATA_WIDTH-1:0] data
  );
  begin
    @(posedge clk_i);
    psel_i    <= 1'b1;
    penable_i <= 1'b0;
    pwrite_i  <= 1'b0;
    paddr_i   <= addr;

    @(posedge clk_i);
    penable_i <= 1'b1;

    wait(pready_o);

    @(posedge clk_i);
    data      = prdata_o;
    psel_i    <= 0;
    penable_i <= 0;
  end
  endtask

  initial begin
    arst_ni   = 0;
    psel_i    = 0;
    penable_i = 0;
    pwrite_i  = 0;
    paddr_i   = 0;
    pwdata_i  = 0;
    pstrb_i   = 0;
    uart_rx_i = 1'b1;

    repeat(10) @(posedge clk_i);
    arst_ni = 1;
    repeat(2) @(posedge clk_i);

    apb_write(5'h00, 32'h00000001);
    apb_write(5'h04, 32'h00000010);
    
    apb_read(5'h08, rd_data);

    apb_write(5'h0C, 32'h00000055);
    apb_write(5'h0C, 32'h000000AA);

    apb_read(5'h10, rd_data);

    #2000;
    $finish;
  end

  logic [31:0] rd_data;

endmodule 