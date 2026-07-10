module carry_lookahead_add_8 (
    input  logic [7:0] a_i,
    input  logic [7:0] b_i,
    input  logic       c_i,
    output logic [7:0] s_o,
    output logic       c_o,
    output logic       p_o,
    output logic       g_o
);
  logic [1:0] c_1;
  logic [1:0] p_1;
  logic [1:0] g_1;
  logic       g_2;
  logic       p_2;

  for (genvar i = 0; i < 2; i = i + 1) begin
    carry_lookahead_add i_carry_lookahead_add (
        .a_i(a_i[4*i+:4]),
        .b_i(b_i[4*i+:4]),
        .c_i(c_1[i]),
        .s_o(s_o[4*i+:4]),
        .p_o(p_1[i]),
        .g_o(g_1[i]),
        .c_o()
    );
  end
  assign c_1[1] = g_1[0] | p_1[0] & c_i;
  assign c_1[0] = c_i;

  assign g_2 = g_1[1] | p_1[1] & g_1[0];
  assign p_2 = &p_1;

  assign c_o = g_2 | p_2 & c_i;
  assign p_o = p_2;
  assign g_o = g_2;

endmodule
