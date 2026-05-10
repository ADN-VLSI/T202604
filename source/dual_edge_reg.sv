(* no_ungroup *)
(* no_boundary_optimization *)

module dual_edge_reg #(
    parameter int WIDTH = 32
) (
    input  logic             arst_ni,
    input  logic             clk_i,
    input  logic [WIDTH-1:0] d_i,
    output logic [WIDTH-1:0] q_o
);

  logic [WIDTH-1:0] q_r;

  always_ff @(posedge clk_i or negedge arst_ni) begin
    if (~arst_ni) begin
      q_r <= '0;
    end else begin
      q_r <= d_i;
    end
  end

  always_ff @(negedge clk_i or negedge arst_ni) begin
    if (arst_ni) begin
      q_o <= '0;
    end else begin
      q_o <= q_r;
    end
  end

endmodule
