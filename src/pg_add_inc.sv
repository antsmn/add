module pg_add_increment #(
  parameter W = 8
) (
  input  logic [W-1:0] a_i,
  input  logic [W-1:0] b_i,
  output logic         c_o,
  output logic [W-1:0] s_o,
  output logic         c1_o,
  output logic [W-1:0] s1_o
);
  logic [W-1:0] p_0;
  logic [W-1:0] g_0;
  logic [W-1:0] n_0;  // k_n
  logic [W-1:0] g_1;
  logic [W-1:0] n_1;
  logic [W-1:0] g_2;

  assign p_0 = a_i ^ b_i;
  assign g_0 = a_i & b_i;
  assign n_0 = a_i | b_i;

  pg_tree #(.W(W)) i_pg_tree (.p_i(n_0), .g_i(g_0), .p_o(n_1), .g_o(g_1));

  assign {c_o, s_o} = {g_1[W-1], p_0 ^ (g_1 << 1)};

  assign g_2 = n_1 | g_1;  // flagged bits mask
  assign {c1_o, s1_o} = {g_2[W-1], p_0 ^ (g_2 << 1 | 1'b1)};  // invert flagged bits


endmodule
