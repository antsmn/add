module carry_increment_rca #(
    parameter W = 8,
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
  logic [W-1:0] p_1;
  logic [W-1:0] p_2;
  logic [W-1:0] g_1;
  logic [W-1:0] g_2;
  logic [W-1:0] g_3;

  for (genvar i = K - 1; i < W; i += K) begin
    g_rca #(K) i_g_rca (
        .p_i(p_1[i-:K]),
        .g_i(g_1[i-:K]),
        .g_o(g_2[i-:K])
    );
  end
  for (genvar i = 2 * K - 1; i < W; i += K) begin
    p_rca #(K) i_p_rca (
        .p_i(p_1[i-:K]),
        .p_o(p_2[i-:K])
    );
    g_inc #(K) i_g_inc (
        .c_i(g_3[i-K]),
        .p_i(p_2[i-:K]),
        .g_i(g_2[i-:K]),
        .g_o(g_3[i-:K])
    );
  end

  assign c_o = g_0[W-1] | (p_0[W-1] & g_3[W-1]);
  assign s_o = p_0 ^ g_3;

  assign g_3[K-1:0] = g_2[K-1:0];

  assign g_1 = (g_0 << 1) | c_i;
  assign p_1 = (p_0 << 1) | 1'b1;
  assign p_0 = a_i ^ b_i;
  assign g_0 = a_i & b_i;

endmodule

module p_rca #(
    parameter W = 4
) (
    input  logic [W-1:0] p_i,
    output logic [W-1:0] p_o
);
  assign p_o = p_i & (p_o << 1 | 1'b1);
endmodule

module g_rca #(
    parameter W = 4
) (
    input  logic [W-1:0] p_i,
    input  logic [W-1:0] g_i,
    output logic [W-1:0] g_o
);
  assign g_o = g_i | p_i & (g_o << 1);
endmodule

module g_inc #(
    parameter W = 4
) (
    input  logic         c_i,
    input  logic [W-1:0] p_i,
    input  logic [W-1:0] g_i,
    output logic [W-1:0] g_o
);
  assign g_o = g_i | (p_i & {W{c_i}});
endmodule
