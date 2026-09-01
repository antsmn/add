module carry_skip_rca #(
  parameter W = 16,
  parameter K = 4
) (
  input  logic [W-1:0] a_i,
  input  logic [W-1:0] b_i,
  input  logic         c_i,
  output logic [W-1:0] s_o,
  output logic         c_o
);
  logic [W-1:0] p_0;
  logic [W-1:0] g_0;
  logic [  W:0] g_1;
  logic [  W:0] g_2;

  for (genvar i = K - 1; i < W; i += K)
  begin

    pg_rca #(K) i_pg_rca_1 (.c_i(1'b0), .p_i(p_0[i-:K]), .g_i(g_0[i-:K]), .c_o(g_1[i+1]), .s_o());
    pg_rca #(K) i_pg_rca_2 (.c_i(g_2[i-K+1]), .p_i(p_0[i-:K]), .g_i(g_0[i-:K]), .s_o(s_o[i-:K]), .c_o());

    mux2 i_mux2 (.z(g_2[i+1]), .a(g_1[i+1]), .b(g_2[i-K+1]), .s(&p_0[i-:K]));

  end
  assign g_2[0] = c_i;

  assign p_0  = a_i ^ b_i;
  assign g_0  = a_i & b_i;

  assign c_o  = g_2[W];

endmodule
