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
  logic [W-1:0] g_1;
  logic [  W:0] g_2;

  for (genvar i = K - 1; i < W; i += K)
  begin

    g_rca #(K - 1) i_g_gen (.c_i(g_2[i+1-K]), .p_i(p_0[i-1-:(K-1)]), .g_i(g_0[i-1-:(K-1)]), .g_o(g_2[  i-:(K-1)]));

    // g_rca #(K) i_g_rca (.c_i(1'b0), .p_i(p_0[i-:K]), .g_i(g_0[i-:K]), .g_o(g_1[i-:K]));
    assign g_1[i-:K] = g_0[i-:K] | p_0[i-:K] & (g_1[i-:K] << 1);

    assign g_2[i+1]  = g_1[i] | (&p_0[i-:K]) & g_2[i+1-K]; // AOI / MUX

  end
  assign g_2[0] = c_i;

  assign p_0 = a_i ^ b_i;
  assign g_0 = a_i & b_i;

  assign s_o = g_2[W-1:0] ^ p_0;
  assign c_o = g_2[W];

endmodule
