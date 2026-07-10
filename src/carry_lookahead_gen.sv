module carry_lookahead_gen (
    input  logic [3:0] g_i,
    input  logic [3:0] p_i,
    input  logic       c_i,
    output logic [2:0] c_o,
    output logic       p_o,
    output logic       g_o
);

  assign c_o[2] = g_i[2] | (p_i[2] & g_i[1]) | (&p_i[2:1] & g_i[0]) | (&p_i[2:0] & c_i);
  assign c_o[1] = g_i[1] | (p_i[1] & g_i[0]) | (&p_i[1:0] & c_i);
  assign c_o[0] = g_i[0] | (p_i[0] & c_i);

  assign g_o = g_i[3] | (p_i[3] & g_i[2]) | (&p_i[3:2] & g_i[1]) | (&p_i[3:1] & g_i[0]);
  assign p_o = &p_i;

endmodule
