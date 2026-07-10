module carry_lookahead_add_64 (
    input  logic [63:0] a_i,
    input  logic [63:0] b_i,
    input  logic        c_i,
    output logic [63:0] s_o,
    output logic        c_o,
    output logic        g_o,
    output logic        p_o
);
  logic [3:0] p_1;
  logic [3:0] g_1;
  logic       p_2;
  logic       g_2;
  logic [3:0] c_1;

  for (genvar i = 0; i < 4; i = i + 1) begin
    carry_lookahead_add_16 i_carry_lookahead_add_16 (
        .a_i(a_i[16*i+:16]),
        .b_i(b_i[16*i+:16]),
        .c_i(c_1[i]),
        .s_o(s_o[16*i+:16]),
        .p_o(p_1[i]),
        .g_o(g_1[i]),
        .c_o()
    );
  end
  carry_lookahead_gen i_carry_lookahead_gen (
      .p_i(p_1),
      .g_i(g_1),
      .c_i(c_i),
      .c_o(c_1[3:1]),
      .p_o(p_2),
      .g_o(g_2)

  );

  assign c_1[0] = c_i;

  assign c_o = g_2 | (p_2 & c_i);
  assign p_o = p_2;
  assign g_o = g_2;

endmodule
