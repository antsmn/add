module pg_abs_difference #(
    parameter W = 32
) (
    input  logic [W-1:0] a_i,
    input  logic [W-1:0] b_i,
    output logic [W-1:0] s_o,
    output logic         c_o
);
  logic [W-1:0] p_0;
  logic [W-1:0] g_0;
  logic [W-1:0] p_1;
  logic [W-1:0] g_1;

  assign p_0 = a_i ^ ~b_i;
  assign g_0 = a_i & ~b_i;

  pg_tree #(
      .W(W)
  ) i_pg_tree (
      .p_i(p_0),
      .g_i(g_0),
      .p_o(p_1),
      .g_o(g_1)
  );

  logic [W:0] p_2;
  logic [W:0] g_2;
  logic [W:0] g_3;

  assign p_2 = p_1 << 1 | 1'b1;  // mask for trailing 1
  assign g_2 = g_1 << 1;

  // g_1 [W-1] = 1'b1 means difference is negative
  assign g_3 = ~((g_2 | ~p_2) &{(W + 1) {g_1[W-1]}});

  assign {c_o, s_o} = g_3 ^ g_2 ^ {1'b1, p_0};

endmodule
