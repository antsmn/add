module carry_lookahead_add_32 (
    input  logic [31:0] a_i,
    input  logic [31:0] b_i,
    input  logic        c_i,
    output logic [31:0] s_o,
    output logic        c_o,
    output logic        g_o,
    output logic        p_o
);
  logic [1:0] p_1;
  logic [1:0] g_1;
  logic [2:0] c_1;

  for (genvar i = 0; i < 2; i = i + 1) begin
    carry_lookahead_add_16 i_carry_lookahead_add_16 (
        .a_i(a_i[16*i+:16]),
        .b_i(b_i[16*i+:16]),
        .c_i(c_1[i]),
        .c_o(c_1[i+1]),
        .s_o(s_o[16*i+:16]),
        .p_o(p_1[i]),
        .g_o(g_1[i])
    );
  end
  assign c_1[0] = c_i;

  assign c_o = c_1[2];
  assign p_o = p_1[1];
  assign g_o = g_1[1];

endmodule
