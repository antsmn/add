module pg_add #(
    parameter W = 32
) (
    input  logic [W-1:0] a_i,
    input  logic [W-1:0] b_i,
    input  logic         c_i,
    output logic [W-1:0] s_o,
    output logic         c_o
);
  logic [W-1:0] t_0;
  logic [W-1:0] p_0;
  logic [W-1:0] g_0;
  logic [W-1:0] t_1;
  logic [W-1:0] g_1;
  logic [W-1:0] g_2;

  assign t_0 = a_i | b_i;
  assign p_0 = a_i ^ b_i;
  assign g_0 = a_i & b_i;

  assign t_1 = t_0 << 1 | 1'b1;
  assign g_1 = g_0 << 1 | c_i;

  pg_tree #(
      .W(W)
  ) i_pg_tree (
      .p_i(t_1),
      .g_i(g_1),
      .g_o(g_2),
      .p_o()
  );

  assign c_o = g_0[W-1] | t_0[W-1] & g_2[W-1];

  assign s_o = p_0 ^ g_2;

endmodule
