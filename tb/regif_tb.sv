`timescale 1ns/1ps

module regif_tb;

    // Signals declaration
    logic arst_ni;
    logic clk_i;
    logic [2:0] addr_i;
    logic [31:0] wdata_i;
    logic we_i;
    logic re_i;
    logic [31:0] rdata_o;
    logic error_o;

    // Interface signals
    logic reg_uart_en, reg_tx_flush, reg_rx_flush;      
    logic [11:0] reg_clk_div;
    logic reg_parity_en, reg_parity_type, reg_second_stop_bit;
    logic [9:0] reg_tx_count, reg_rx_count;
    logic [7:0] reg_tx_data, reg_rx_data;
    logic reg_tx_data_valid, reg_tx_data_ready;
    logic reg_rx_data_valid, reg_rx_data_ready;

    // Instantiate the DUT (Design Under Test)
    regif dut (.*);

    // Clock generation (10ns period)
    always #5 clk_i = ~clk_i;

    // Task for Write Operation
    task write_reg(input [2:0] addr, input [31:0] data); 
        begin
            @(posedge clk_i);  
            addr_i  = addr;
            wdata_i = data;
            we_i    = 1;
            re_i    = 0;
            @(posedge clk_i);
            we_i    = 0;
            wdata_i = 0;
        end
    endtask

    // Task for Read Operation
    task read_reg(input [2:0] addr);
        begin
            @(posedge clk_i);
            addr_i  = addr;
            we_i    = 0;
            re_i    = 1;
            @(posedge clk_i);
            re_i    = 0;
        end
    endtask

    initial begin
        // Dump waves for waveform viewer
        $dumpfile("regif_tb.vcd");
        $dumpvars(0, regif_tb);

        // Initialization
        clk_i = 0;
        arst_ni = 0;
        addr_i = 0;
        wdata_i = 0;
        we_i = 0;
        re_i = 0;   
        
        // Mock inputs
        reg_tx_count = 10'd5;
        reg_rx_count = 10'd2;
        reg_rx_data = 8'hAB;
        reg_rx_data_valid = 1;
        reg_tx_data_ready = 1;

        // Reset sequence
        #20 arst_ni = 1;

        // Test sequences
        $display("Starting Register Test...");
        
        write_reg(3'h0, 32'h0000_0007); // Write to UART_CTRL
        read_reg(3'h2);                 // Read from UART_STAT
        
        #20;
        $display("Data read from Status Register: %h", rdata_o);

        #50 $finish;
    end

endmodule