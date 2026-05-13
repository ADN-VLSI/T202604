module apb_mem_tb;

  //////////////////////////////////////////////////////////////////////////////////////////////////
  // MACROS
  //////////////////////////////////////////////////////////////////////////////////////////////////
  
  `define MEMORY(__ADDR__)  u_dut.memory_inst.mem[``__ADDR__``]

  //////////////////////////////////////////////////////////////////////////////////////////////////
  // PARAMETERS
  //////////////////////////////////////////////////////////////////////////////////////////////////

  localparam int LOCAL_ADDR_WIDTH = 10;
  localparam int LOCAL_DATA_WIDTH = 32;

  localparam bit debug = 1'b1;

  //////////////////////////////////////////////////////////////////////////////////////////////////
  // SIGNALS
  //////////////////////////////////////////////////////////////////////////////////////////////////
  
  logic                              arst_n;
  logic                              clk;
  logic                              psel;
  logic                              penable;
  logic [      LOCAL_ADDR_WIDTH-1:0] paddr;
  logic                              pwrite;
  logic [      LOCAL_DATA_WIDTH-1:0] pwdata;
  logic [(LOCAL_DATA_WIDTH / 8)-1:0] pstrb;
  logic                              pready;
  logic [      LOCAL_DATA_WIDTH-1:0] prdata;
  logic                              pslverr;

  //////////////////////////////////////////////////////////////////////////////////////////////////
  // DUT INSTANCE
  //////////////////////////////////////////////////////////////////////////////////////////////////
  
  apb_mem #(
      .ADDR_WIDTH(LOCAL_ADDR_WIDTH),
      .DATA_WIDTH(LOCAL_DATA_WIDTH)
  ) u_dut (
      .arst_ni  (arst_n),
      .clk_i    (clk),
      .psel_i   (psel),
      .penable_i(penable),
      .paddr_i  (paddr),
      .pwrite_i (pwrite),
      .pwdata_i (pwdata),
      .pstrb_i  (pstrb),
      .pready_o (pready),
      .prdata_o (prdata),
      .pslverr_o(pslverr)
  );

  //////////////////////////////////////////////////////////////////////////////////////////////////
  // METHODS
  //////////////////////////////////////////////////////////////////////////////////////////////////

  task automatic read(
    input  logic [LOCAL_ADDR_WIDTH-1:0] addr,
    output logic [LOCAL_DATA_WIDTH-1:0] data
  );
    @(posedge clk);
    psel    <= 1'b1;
    penable <= 1'b0;
    paddr   <= addr;
    pwrite  <= 1'b0;
    pwdata  <= '0;
    pstrb   <= '0;
    @(posedge clk);
    penable <= 1'b1;
    do @(posedge clk);
    while (!pready);
    psel <= 1'b0;
    data = prdata;
    if (debug) $display("Read from address 0x%8h: 0x%8h", addr, data);
  endtask

  task automatic write(
    input logic [LOCAL_ADDR_WIDTH-1:0] addr,
    input logic [LOCAL_DATA_WIDTH-1:0] data,
    input logic [(LOCAL_DATA_WIDTH / 8)-1:0] strobe = '1
  );
    @(posedge clk);
    psel    <= 1'b1;
    penable <= 1'b0;
    paddr   <= addr;
    pwrite  <= 1'b1;
    pwdata  <= data;
    pstrb   <= strobe;
    @(posedge clk);
    penable <= 1'b1;
    do @(posedge clk);
    while (!pready);
    psel <= 1'b0;
    if (debug) $display("Wrote to address 0x%8h: 0x%8h (strb 0b%4b)", addr, data, strobe);
  endtask
  
  //////////////////////////////////////////////////////////////////////////////////////////////////
  // PROCEDURALS
  //////////////////////////////////////////////////////////////////////////////////////////////////
  
  initial begin

    #100ns;

    arst_n  <= '0;
    clk     <= '0;
    psel    <= '0;
    penable <= '0;
    paddr   <= '0;
    pwrite  <= '0;
    pwdata  <= '0;
    pstrb   <= '0;

    #100ns;

    arst_n <= '1;

    #100ns;

    // `MEMORY(3) = 'hf0;
    // `MEMORY(2) = 'h0d;
    // `MEMORY(1) = 'hca;
    // `MEMORY(0) = 'hfe;

    fork
      forever begin
        #5ns clk <= ~clk;
      end
    join_none

    write(3, 'hf0, 'b0001);
    write(2, 'h0d, 'b0001);
    write(1, 'hca, 'b0001);
    write(0, 'hfe, 'b0001);

    for (int i = 0; i < 5; i++) begin
      logic [LOCAL_DATA_WIDTH-1:0] data;
      read(i, data);
      // $display("Read from address %0h: %0h", i, data);
    end

    $finish;
  end

endmodule
