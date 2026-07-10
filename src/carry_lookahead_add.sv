module carry_lookahead_add (
    input  logic [3:0] a_i,
    input  logic [3:0] b_i,
    input  logic       c_i,
    output logic [3:0] s_o,
    output logic       c_o,
    output logic       p_o,
    output logic       g_o
);
  logic [3:0] p;
  logic [3:0] g;
  logic [3:0] c;

  assign p = a_i ^ b_i;
  assign g = a_i & b_i;

  assign c[0] = c_i;

  carry_lookahead_gen i_carry_lookahead_gen (
      .p_i(p),
      .g_i(g),
      .c_i(c[0]),
      .c_o(c[3:1]),
      .p_o(p_o),
      .g_o(g_o)
  );

  assign c_o = g[3] | (p[3] & g[2]) | (&p[3:2] & g[1]) | (&p[3:1] & g[0]) | (&p[3:0] & c_i);
  // assign c_o = g_o | p_o & c_i;
  // assign c_o = g[3] | (p[3] & c[3]);

  assign s_o = p ^ c;

endmodule
