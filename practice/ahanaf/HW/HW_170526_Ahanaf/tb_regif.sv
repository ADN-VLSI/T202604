module tb_regif;

  ////////////////////////////////////////////////////////////////////////////////////////////////
  // Testbench Signals
  ////////////////////////////////////////////////////////////////////////////////////////////////

  logic        arst_ni;
  logic        clk_i;
  logic [ 2:0] addr_i;
  logic [31:0] wdata_i;
  logic        we_i;
  logic [31:0] rdata_o;
  logic        error_o;

  logic [31:0] reg0_i;
  logic [31:0] reg1_i;
  logic [31:0] reg2_i;
  logic [31:0] reg3_i;
  logic [31:0] reg4_o;
  logic [31:0] reg5_o;
  logic [31:0] reg6_o;
  logic [31:0] reg7_o;

  ////////////////////////////////////////////////////////////////////////////////////////////////
  // Instantiate the Design Under Test (DUT)
  ////////////////////////////////////////////////////////////////////////////////////////////////

  regif dut (
      .arst_ni(arst_ni),
      .clk_i  (clk_i),
      .addr_i (addr_i),
      .wdata_i(wdata_i),
      .we_i   (we_i),
      .rdata_o(rdata_o),
      .error_o(error_o),
      .reg0_i (reg0_i),
      .reg1_i (reg1_i),
      .reg2_i (reg2_i),
      .reg3_i (reg3_i),
      .reg4_o (reg4_o),
      .reg5_o (reg5_o),
      .reg6_o (reg6_o),
      .reg7_o (reg7_o)
  );

  ////////////////////////////////////////////////////////////////////////////////////////////////
  // Methods for Testbench Operations
  ////////////////////////////////////////////////////////////////////////////////////////////////

  // Clock Generation
  task automatic generate_clock();
    fork
      forever begin
        clk_i <= '0;
        #5ns;
        clk_i <= '1;
        #5ns;
      end
    join_none
  endtask

  // Task for Reset
  task reset_dut();
    arst_ni <= '0;
    addr_i  <= '0;
    wdata_i <= '0;
    we_i    <= '0;
    reg0_i  <= '0;
    reg1_i  <= '0;
    reg2_i  <= '0;
    reg3_i  <= '0;
    #15ns;
    arst_ni <= '1;
    $display("[RESET] DUT Reset Done at %0t", $time);
  endtask

  // Task for Write Operation
  task write_reg(input logic [2:0] addr, input logic [31:0] data);
    @(posedge clk_i);
    addr_i  <= addr;
    wdata_i <= data;
    we_i    <= 1'b1;
    @(posedge clk_i);  // Wait for clock edge to sample
    we_i <= 1'b0;  // De-assert write enable
  endtask

  // Task for Read and Check Operation
  task read_and_check(input logic [2:0] addr, input logic [31:0] expected_data,
                      input logic expected_error);
    @(posedge clk_i);
    addr_i <= addr;
    we_i   <= 1'b0;

    @(posedge clk_i);
    if (rdata_o === expected_data && error_o === expected_error) begin
      $display("[SUCCESS] Addr: 0x%0h | Read Data: 0x%0h (Expected: 0x%0h) | Error: %b", addr,
               rdata_o, expected_data, error_o);
    end else begin
      $display(
          "[ERROR MISMATCH] Addr: 0x%0h | Read Data: 0x%0h (Expected: 0x%0h) | Error: %b (Expected: %b)",
          addr, rdata_o, expected_data, error_o, expected_error);
    end

  endtask

  // Main Test Sequence
  initial begin
    // Initialize inputs for Read-Only registers
    reg0_i <= 32'hAAAA_0000;
    reg1_i <= 32'hBBBB_1111;
    reg2_i <= 32'hCCCC_2222;
    reg3_i <= 32'hDDDD_3333;

    // Apply Reset
    reset_dut();

    generate_clock();

    $display("\n--- Running TEST 1: Read RO Registers ---");
    read_and_check(3'h0, 32'hAAAA_0000, 1'b0);
    read_and_check(3'h1, 32'hBBBB_1111, 1'b0);

    $display("\n\n\n--- Running TEST 2: Write & Read RW Registers ---");
    write_reg(3'h4, 32'h1234_5678);
    write_reg(3'h7, 32'hCAFE_BABE);

    read_and_check(3'h4, 32'h1234_5678, 1'b0);
    read_and_check(3'h7, 32'hCAFE_BABE, 1'b0);

    $display("\n\n\n--- Running TEST 3: Writing to RO Register (Error Check) ---");


    write_reg(3'h0, 32'h9999_9999);  // Attempt to write to RO register

    if (error_o === 1'b1) begin
      $display("[SUCCESS] Error flag correctly asserted on writing to RO register!");
    end else begin
      $display("[FAIL] Error flag NOT asserted on writing to RO register!");
    end

    // TEST 4: Verify Reset Values of RW Registers
    $display("\n\n\n--- Running TEST 4: Verify Reset Again ---");

    reset_dut();

    read_and_check(3'h4, 32'h0000_0000, 1'b0);

    $display("\nAll Tests Completed.\n\n");

    $finish;

  end

endmodule
