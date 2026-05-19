module regif_tb;

     logic arst_ni_tb;
     logic clk_i_tb;

     logic [ 2:0] addr_i_tb;
     logic [31:0] wdata_i_tb;
     logic        we_i_tb;
     logic [31:0] rdata_o_tb;
     logic        error_o_tb;

    logic [31:0] reg0_i_tb;  // 0x0 RO
    logic [31:0] reg1_i_tb;  // 0x1 RO
    logic [31:0] reg2_i_tb;  // 0x2 RO
    logic [31:0] reg3_i_tb;  // 0x3 RO
    logic [31:0] reg4_o_tb;  // 0x4 RW
    logic [31:0] reg5_o_tb;   // 0x5 RW
    logic [31:0] reg6_o_tb;  // 0x6 RW
    logic [31:0] reg7_o_tb;   // 0x7 RW


regif dut(
    .arst_ni(arst_ni_tb),
    .clk_i(clk_i_tb),
    .addr_i(addr_i_tb),
    .wdata_i(wdata_i_tb),
    .we_i(we_i_tb),
    .rdata_o(rdata_o_tb),
    .error_o(error_o_tb),
    .reg0_i(reg0_i_tb),
    .reg1_i(reg1_i_tb),
    .reg2_i(reg2_i_tb),
    .reg3_i(reg3_i_tb),
    .reg4_o(reg4_o_tb),
    .reg5_o(reg5_o_tb),
    .reg6_o(reg6_o_tb),
    .reg7_o(reg7_o_tb)
);

initial begin
    clk_i_tb = 0;
    forever #10 clk_i_tb = ~clk_i_tb;  
end

initial begin
    // Initialize inputs
    arst_ni_tb = 0; // Apply reset
    addr_i_tb = 0;
    wdata_i_tb = 0;
    we_i_tb = 0;
    #10;
    $display("Applying reset...");
    $display("reg4_o = %h rdata_o = %h", reg4_o_tb, rdata_o_tb );
    $display("reg5_o = %h rdata_o = %h", reg5_o_tb, rdata_o_tb);
    $display("reg6_o = %h rdata_o = %h", reg6_o_tb, rdata_o_tb);
    $display("reg7_o = %h rdata_o = %h \n", reg7_o_tb, rdata_o_tb,); 
       
    // Assigning values to RO registers to check if they are read correctly
    reg0_i_tb = 32'h11111111;
    reg1_i_tb = 32'h22222222;
    reg2_i_tb = 32'h33333333;
    reg3_i_tb = 32'h44444444;
    
    #20;
    arst_ni_tb = 1; // clear reset 

    // Test writing to RW registers
    $display("Testing write to RW registers..."); 
    @(posedge clk_i_tb);
    addr_i_tb = 3'h4; wdata_i_tb = 32'hA5A5A5A5; we_i_tb = 1; // Write to reg4_o
    @(posedge clk_i_tb);
    addr_i_tb = 3'h5; wdata_i_tb = 32'h5A5A5A5A; we_i_tb = 1; // Write to reg5_o
    @(posedge clk_i_tb);
    addr_i_tb = 3'h6; wdata_i_tb = 32'hFF; we_i_tb = 1; // Write to reg6_o half data  

    // Test reading from RO registers
    $display("\nTesting read from RO registers:"); 
    #10; 
    @(posedge clk_i_tb);
    addr_i_tb = 3'h0; we_i_tb = 0; // Read from reg0_i
    $display("write enable = %b addr_i = %h reg0_i = %h rdata_o = %h ", we_i_tb, addr_i_tb,reg0_i_tb, rdata_o_tb);
    @(posedge clk_i_tb);
    addr_i_tb = 3'h1; we_i_tb = 0; // Read from reg1_i
    $display("write enable = %b addr_i = %h reg1_i = %h rdata_o = %h ", we_i_tb, addr_i_tb,reg1_i_tb, rdata_o_tb);
    @(posedge clk_i_tb);
    addr_i_tb = 3'h2; we_i_tb = 0; // Read from reg2_i
    $display("write enable = %b addr_i = %h reg2_i = %h rdata_o = %h ", we_i_tb, addr_i_tb,reg2_i_tb, rdata_o_tb);
    @(posedge clk_i_tb);
    addr_i_tb = 3'h3; we_i_tb = 0; // Read from reg3_i
    $display("write enable = %b addr_i = %h reg3_i = %h rdata_o = %h \n", we_i_tb, addr_i_tb,reg3_i_tb, rdata_o_tb);    

    // Test reading from RW registers (should have the written values)
    $display("Testing read from RW registers:"); 
    @(posedge clk_i_tb);
    addr_i_tb = 3'h4; we_i_tb = 0; // Read from reg4_o
    $display("write enable = %b addr_i = %h reg4_o = %h rdata_o = %h", we_i_tb, addr_i_tb, reg4_o_tb, rdata_o_tb);
    @(posedge clk_i_tb);
    addr_i_tb = 3'h5; we_i_tb = 0; // Read from reg5_o
    $display("write enable = %b addr_i = %h reg5_o = %h rdata_o = %h", we_i_tb, addr_i_tb, reg5_o_tb, rdata_o_tb);
    @(posedge clk_i_tb);
    addr_i_tb = 3'h6; we_i_tb = 0; // Read from reg6_o
    $display("write enable = %b addr_i = %h reg6_o = %h rdata_o = %h", we_i_tb, addr_i_tb, reg6_o_tb, rdata_o_tb);
    @(posedge clk_i_tb);
    addr_i_tb = 3'h7; we_i_tb = 0; // Read from reg7_o
    $display("write enable = %b addr_i = %h reg7_o = %h rdata_o = %h \n", we_i_tb, addr_i_tb, reg7_o_tb, rdata_o_tb);


    // Test error condition (write to RO register)
    $display("Testing error condition (write to RO register):");
    @(posedge clk_i_tb);
    addr_i_tb = 3'h2; wdata_i_tb = 32'hDEADBEEF; we_i_tb = 1; // Attempt to write to reg2_i
    #10; 
    $display("Error signal after invalid write: %b\n", error_o_tb);

    #100;
    $finish;    

end

endmodule