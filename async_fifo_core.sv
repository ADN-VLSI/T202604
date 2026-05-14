// Simple & Unique Asynchronous FIFO for CDC
module async_fifo_core #(
    parameter W = 8, // Data Width
    parameter D = 16 // Depth
)(
    input  logic         wclk, wrst_n, wen,
    input  logic [W-1:0] wdata,
    output logic         wfull,

    input  logic         rclk, rrst_n, ren,
    output logic [W-1:0] rdata,
    output logic         rempty
);

    localparam AW = $clog2(D);
    logic [W-1:0] storage [D];
    logic [AW:0] wptr_bin, rptr_bin;
    logic [AW:0] wptr_gray, rptr_gray;
    logic [AW:0] wptr_s1, wptr_s2, rptr_s1, rptr_s2;

    // --- Write Domain ---
    always_ff @(posedge wclk or negedge wrst_n) begin
        if (!wrst_n) {wptr_bin, wptr_gray} <= '0;
        else if (wen && !wfull) begin
            storage[wptr_bin[AW-1:0]] <= wdata;
            wptr_bin <= wptr_bin + 1;
            wptr_gray <= (wptr_bin + 1) ^ ((wptr_bin + 1) >> 1);
        end
    end

    // Sync Read Pointer to Write Clock
    always_ff @(posedge wclk or negedge wrst_n) begin
        if (!wrst_n) {rptr_s2, rptr_s1} <= '0;
        else         {rptr_s2, rptr_s1} <= {rptr_s1, rptr_gray};
    end
    assign wfull = (wptr_gray == {~rptr_s2[AW:AW-1], rptr_s2[AW-2:0]});

    // --- Read Domain ---
    always_ff @(posedge rclk or negedge rrst_n) begin
        if (!rrst_n) {rptr_bin, rptr_gray} <= '0;
        else if (ren && !rempty) begin
            rptr_bin <= rptr_bin + 1;
            rptr_gray <= (rptr_bin + 1) ^ ((rptr_bin + 1) >> 1);
        end
    end
    assign rdata = storage[rptr_bin[AW-1:0]];

    // Sync Write Pointer to Read Clock
    always_ff @(posedge rclk or negedge rrst_n) begin
        if (!rrst_n) {wptr_s2, wptr_s1} <= '0;
        else         {wptr_s2, wptr_s1} <= {wptr_s1, wptr_gray};
    end
    assign rempty = (rptr_gray == wptr_s2);

endmodule