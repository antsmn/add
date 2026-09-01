module pg_dec #(
  parameter W = 8
) (
  input  logic [W-1:0] a_i,
  output logic [W-1:0] s_o
);
  // inverting bits from the lsb up to and including the least significant one

  logic [W-1:0] p_0;
  logic [W-1:0] g_0;
  logic [W-1:0] p_1;

  // pg and

  assign p_0 = ~a_i;
  assign g_0 = '0;

  pg_tree #(
    .W(W)
  ) i_pg_tree (
    .g_i(g_0),
    .p_i(p_0),
    .p_o(p_1),
    .g_o()
  );

  assign s_o = a_i ^ (p_1 << 1 | 1'b1);

endmodule
