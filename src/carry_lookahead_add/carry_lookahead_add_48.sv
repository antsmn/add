module carry_lookahead_add_48 (
    input  logic [47:0] a_i,
    input  logic [47:0] b_i,
    input  logic        c_i,
    output logic [47:0] s_o,
    output logic        c_o,
    output logic        g_o,
    output logic        p_o
);
  logic [3:0] p_1;
  logic [3:0] g_1;
  logic [3:0] c_1;

  for (genvar i = 0; i < 3; i = i + 1) begin
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
  assign p_1[3] = 1'b1;
  assign g_1[3] = 1'b0;
  carry_lookahead_gen i_carry_lookahead_gen (
      .g_i(g_1),
      .p_i(p_1),
      .c_i(c_1[0]),
      .c_o(c_1[3:1]),
      .p_o(),
      .g_o()
  );

  assign c_1[0] = c_i;
  assign c_o = c_1[3];
  assign p_o = p_1[1];
  assign g_o = g_1[1];

endmodule
