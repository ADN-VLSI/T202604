module cdc_fifo #(
    parameter int DATA_WIDTH = 8,
    parameter int SIZE = 4
) (

    input  logic                  data_in_arst_ni,
    input  logic                  data_in_clk_i,
    input  logic [DATA_WIDTH-1:0] data_in_i,
    input  logic                  data_in_valid_i,
    output logic                  data_in_ready_o,
    output logic [        SIZE:0] data_in_count_o,

    input  logic                  data_out_arst_ni,
    input  logic                  data_out_clk_i,
    output logic [DATA_WIDTH-1:0] data_out_o,
    output logic                  data_out_valid_o,
    input  logic                  data_out_ready_i,
    output logic [        SIZE:0] data_out_count_o
);


  /* verilog_format: off */
  logic          common_arst_ni;

  //             SIGNAL    // CLOCK   // FORMAT // DESCRIPTION
  //-----------------------//---------//--------//-------------------------------------------
  logic [SIZE:0] wr_addr;  // in_clk  // binary // Write pointer 
  logic [SIZE:0] wr_addr_; // out_clk // binary // Write pointer 
  logic [SIZE:0] wpgi;     // in_clk  // gray   // Write pointer reg in
  logic [SIZE:0] wpgo;     // out_clk // gray   // Write pointer reg out
  logic [SIZE:0] wp_pass;  // in_clk  // gray   // Write pointer that will cross clock domain
  logic          wr_en;    // in_clk  //        // Write enable
  logic          meq_ic;   // in_clk  //        // MSB of write pointer equals MSB of read pointer
  logic          nmeq_ic;  // in_clk  //        // NON-MSB of write pointer equals NON-MSB of read pointer

  //             SIGNAL    // CLOCK   // FORMAT // DESCRIPTION
  //-----------------------//---------//--------//-------------------------------------------
  logic [SIZE:0] rd_addr;  // out_clk // binary // Read pointer 
  logic [SIZE:0] rd_addr_; // in_clk  // binary // Read pointer 
  logic [SIZE:0] rpgi;     // out_clk // gray   // Read pointer reg in
  logic [SIZE:0] rpgo;     // in_clk  // gray   // Read pointer reg out
  logic [SIZE:0] rp_pass;  // out_clk // gray   // Read pointer that will cross clock domain
  logic [SIZE:0] rd_en;    // out_clk //        // Read enable
  logic          meq_oc;   // out_clk //        // MSB of write pointer equals MSB of read pointer
  logic          nmeq_oc;  // out_clk //        // NON-MSB of write pointer equals NON-MSB of read pointer
  /* verilog_format: on */

  always_comb common_arst_ni = data_in_arst_ni & data_out_arst_ni;

  always_comb meq_ic = (wr_addr[SIZE] == rd_addr_[SIZE]);
  always_comb nmeq_ic = (wr_addr[SIZE-1:0] == rd_addr_[SIZE-1:0]);

  always_comb meq_oc = (wr_addr_[SIZE] == rd_addr[SIZE]);
  always_comb nmeq_oc = (wr_addr_[SIZE-1:0] == rd_addr[SIZE-1:0]);

  always_comb data_in_count_o = wr_addr - rd_addr_;
  always_comb data_out_count_o = wr_addr_ - rd_addr;

  always_comb data_in_ready_o = (meq_ic | ~nmeq_ic);
  always_comb data_out_valid_o = (~meq_oc | ~nmeq_oc);

  always_comb wr_en = data_in_valid_i & data_in_ready_o;
  always_comb rd_en = data_out_valid_o & data_out_ready_i;

  always_ff @(posedge data_in_clk_i or negedge common_arst_ni) begin
    if (~common_arst_ni) begin
      wp_pass <= '0;
    end else if (wr_en) begin
      wp_pass <= wpgi;
    end
  end

  always_ff @(posedge data_out_clk_i or negedge common_arst_ni) begin
    if (~common_arst_ni) begin
      rp_pass <= '0;
    end else if (rd_en) begin
      rp_pass <= rpgi;
    end
  end

  generic_dp_mem #(
      .ADDR_WIDTH(SIZE),
      .DATA_WIDTH(DATA_WIDTH)
  ) mem (
      .clk_i  (data_in_clk_i),
      .waddr_i(wr_addr[SIZE-1:0]),
      .wdata_i(data_in_i),
      .we_i   (wr_en),
      .raddr_i(rd_addr[SIZE-1:0]),
      .rdata_o(data_out_o)
  );

  bin_to_gray #(
      .N(SIZE + 1)
  ) b2g_w (
      .bin_i (wr_addr + 1),
      .gray_o()
  );

  bin_to_gray #(
      .N(SIZE + 1)
  ) b2g_r (
      .bin_i (rd_addr + 1),
      .gray_o()
  );

  gray_to_bin #(
      .N(SIZE + 1)
  ) g2b_wi (
      .gray_i(wp_pass),
      .bin_o (wr_addr)
  );

  gray_to_bin #(
      .N(SIZE + 1)
  ) g2b_ro (
      .gray_i(rp_pass),
      .bin_o (rd_addr)
  );

  gray_to_bin #(
      .N(SIZE + 1)
  ) g2b_wo (
      .gray_i(wpgo),
      .bin_o (wr_addr_)
  );

  gray_to_bin #(
      .N(SIZE + 1)
  ) g2b_ri (
      .gray_i(rpgo),
      .bin_o (rd_addr_)
  );

  dual_edge_reg #(
      .WIDTH(SIZE + 1)
  ) rd_ptr_ic (
      .arst_ni(common_arst_ni),
      .clk_i  (data_in_clk_i),
      .d_i    (rd_pass),
      .q_o    (rd_addr_)
  );

  dual_edge_reg #(
      .WIDTH(SIZE + 1)
  ) wr_ptr_oc (
      .arst_ni(common_arst_ni),
      .clk_i  (data_out_clk_i),
      .d_i    (wp_pass),
      .q_o    (wr_addr_)
  );

endmodule
