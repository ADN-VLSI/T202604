module top_tb;
    logic clk_w = 0, clk_r = 0, rst_n = 0;
    logic wen = 0, ren = 0, full, empty;
    logic [7:0] din, dout;

    async_fifo_core #(8, 16) dut (
        .wclk(clk_w), .wrst_n(rst_n), .wen(wen), .wdata(din), .wfull(full),
        .rclk(clk_r), .rrst_n(rst_n), .ren(ren), .rdata(dout), .rempty(empty)
    );

    always #4 clk_w = ~clk_w; 
    always #10 clk_r = ~clk_r; 

    initial begin
        rst_n = 0; #25 rst_n = 1;
        
        // Data push
        @(posedge clk_w);
        repeat(10) begin
            if(!full) begin
                wen = 1; din = $urandom;
                @(posedge clk_w);
            end
        end
        wen = 0;

        // Data pop
        repeat(12) begin
            @(posedge clk_r) ren = !empty;
        end
        #50 $finish;
    end
endmodule