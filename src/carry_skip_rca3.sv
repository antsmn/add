module carry_skip_rca #(
    parameter W = 16,
    parameter K = 4
) (
    input  logic [W-1:0] a_i,
    input  logic [W-1:0] b_i,
    input  logic         c_i,
    output logic [W-1:0] s_o,
    output logic         c_o
);
  logic [W-1:0] p_0;
  logic [W-1:0] g_0;
  logic [  W:0] g_1;
  logic [  W:0] c;

  genvar i;

  for (i = K - 1; i < W; i += K) begin
    pg_rca #(
        .W(K)
    ) i_pg_rca (
        .p_i(p_0[i-:K]),
        .g_i(g_0[i-:K]),
        .c_i(c[i-K+1]),
        .s_o(s_o[i-:K]),
        .c_o(g_1[i+1])
    );
    MUX2_X1 i_MUX2 (
        .Z(c[i+1]),
        .A(g_1[i+1]),
        .B(c[i-K+1]),
        .S(&p_0[i-:K])
    );

  end
  assign c[0] = c_i;

  assign p_0  = a_i ^ b_i;
  assign g_0  = a_i & b_i;

  assign c_o  = c[W];

endmodule
