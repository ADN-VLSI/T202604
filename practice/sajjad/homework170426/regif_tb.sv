module regif_tb;

  // 1. Signals Declaration
  logic        clk_i = 0;
  logic        arst_ni = 1;
  logic        we_i = 0;
  logic [2:0]  addr_i = 0;
  logic [31:0] wdata_i = 0;
  
  logic        error_o;
  logic [31:0] rdata_o;
  
  // Read-only Inputs to DUT (Decimal values deya hoyeche test er shubidha jonno)
  logic [31:0] reg0_i = 32'd10;  // Reg0 er value 10
  logic [31:0] reg1_i = 32'd20;  // Reg1 er value 20
  logic [31:0] reg2_i = 32'd30;  // Reg2 er value 30
  logic [31:0] reg3_i = 32'd40;  // Reg3 er value 40
  
  // Read-Write Outputs from DUT
  logic [31:0] reg4_o, reg5_o, reg6_o, reg7_o;

  // Test monitoring flags (0 = Fail, 1 = Pass)
  bit tc1_ok, tc2_ok, tc3_ok, tc4_ok;

  // 2. DUT Instantiation
  regif dut (.*);

  // 3. Clock Generation (10ns Period)
  always #5 clk_i = ~clk_i;

  // 4. Test Stimulus
  initial begin
    
    // --- TC_01: Asynchronous Reset Check ---
    $display("[TC1] Testing Reset...");
    arst_ni = 0; // Reset active 
    #5; 
    if (reg4_o == 32'h0 && reg7_o == 32'h0) tc1_ok = 1;
    else $display("[FAIL] Reset test failed!");
    
    arst_ni = 1; // Reset release 
    #5;

    // --- TC_02: Read-Only Registers Check ---
    $display("[TC2] Testing Read-Only Registers (Expecting: 10, 20)...");
    @(posedge clk_i);
    addr_i = 3'h0; 
    #1; // delay
    if (rdata_o == reg0_i) begin
      addr_i = 3'h1; 
      #1;
      if (rdata_o == reg1_i) tc2_ok = 1;
    end
    if (!tc2_ok) $display("[FAIL] Read-only register check failed!");

    // --- TC_03: Normal Write & Read (Address 4) ---
    $display("[TC3] Testing Write and Read at Address 4...");
    @(posedge clk_i);
    addr_i  = 3'h4; 
    wdata_i = 32'h1234_5678; 
    we_i    = 1;          // Write Enable On
    
    @(posedge clk_i);    // 1 clock cycle wait (Write sesh hobe ekhane)
    we_i    = 0;          // Write Enable Off
    
    #1;                   // Read data stable hobar break
    if (reg4_o == 32'h1234_5678 && rdata_o == 32'h1234_5678) tc3_ok = 1;
    else $display("[FAIL] Write/Read mismatch at Address 4!");

    // --- TC_04: Illegal Write to Read-Only Reg (Timing Fixed) ---
    $display("[TC4] Testing Illegal Write Error (Writing to Reg2)...");
    @(posedge clk_i);
    addr_i  = 3'h2;       // Reg2 holo Read-Only (value 30)
    wdata_i = 32'hDEAD_BEEF; 
    we_i    = 1;          // Bhul kore write korar chesta 
    
    #1;                   // we_i = 1 thaka obsthay combinational error_o check korchi
    if (error_o == 1'b1) tc4_ok = 1; 
    else $display("[FAIL] Illegal write did not generate error!");
    
    @(posedge clk_i);    // Poroborti clock edge-e driver off kore dichchi
    we_i = 0;

    // --- Final Status Display ---
    #20;
    $display("\n=======================================");
    if (tc1_ok && tc2_ok && tc3_ok && tc4_ok) begin
      $display("   [SUCCESS] STATUS: ALL TESTS OK!     ");
    end else begin
      $display("   [ERROR] STATUS: SOME TESTS FAILED!  ");
      $display("   Results -> TC1:%b, TC2:%b, TC3:%b, TC4:%b", tc1_ok, tc2_ok, tc3_ok, tc4_ok);
    end
    $display("=======================================\n");

    $finish;
  end

endmodule