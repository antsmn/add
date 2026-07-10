module carry_select_rca #(
    parameter W = 16,
    parameter K = 4
) (
    input  logic [W-1:0] a_i,
    input  logic [W-1:0] b_i,
    input  logic         c_i,
    output logic [W-1:0] s_o,
    output logic         c_o
);
  // The conditional-sum adder is a logically redundant form of the Sklansky adder, taking two multiplexers to implement the same function as a black prefix cell

  localparam int NS = $clog2(W / K);
  logic [ NS:0][W-1:0] c_0;
  logic [ NS:0][W-1:0] s_0;
  logic [ NS:0][W-1:0] s_1;
  logic [ NS:0][W-1:0] c_1;
  logic [W-1:0]        p_0;
  logic [W-1:0]        g_0;
  logic [W-1:0]        g_1;
  logic [W-1:0]        g_2;

  assign p_0 = a_i ^ b_i;
  assign g_0 = a_i & b_i;

  for (genvar i = 2 * K - 1; i < W; i += K) begin
    assign {c_0[0][i], g_1[i-:K]} = {g_0[i-:K] | (p_0[i-:K] & g_1[i-:K]), 1'b0};
    assign {c_1[0][i], g_2[i-:K]} = {g_0[i-:K] | (p_0[i-:K] & g_2[i-:K]), 1'b1};
  end
  assign {c_1[0][K-1], g_2[K-1:0]} = {g_0[K-1:0] | (p_0[K-1:0] & g_2[K-1:0]), c_i};

  assign s_0[0] = p_0 ^ g_1;
  assign s_1[0] = p_0 ^ g_2;

  for (genvar i = 1; i < NS + 1; i += 1) begin
    localparam P = K * (2 ** (i - 1));
    localparam L = K * (2 ** (i));
    for (genvar j = L - 1; j < W; j += L) begin
      for (genvar k = j; k > j - P; k -= K) begin

        if (k > L - 1) begin
          MUX2_X1 i_MUX2 (
              .Z(c_0[i][k]),
              .S(c_0[i-1][j-P]),
              .A(c_0[i-1][k]),
              .B(c_1[i-1][k])
          );
          MUX2_X1_W #(K) i_MUX2_W (
              .Z(s_0[i][k-:K]),
              .S(c_0[i-1][j-P]),
              .A(s_0[i-1][k-:K]),
              .B(s_1[i-1][k-:K])
          );
        end

        MUX2_X1 i_MUX2 (
            .Z(c_1[i][k]),
            .S(c_1[i-1][j-P]),
            .A(c_0[i-1][k-:1]),
            .B(c_1[i-1][k-:1])
        );
        MUX2_X1_W #(K) i_MUX2_W (
            .Z(s_1[i][k-:K]),
            .S(c_1[i-1][j-P]),
            .A(s_0[i-1][k-:K]),
            .B(s_1[i-1][k-:K])
        );
      end
      assign s_1[i][j-P-:P] = s_1[i-1][j-P-:P];
      assign c_1[i][j-P-:1] = c_1[i-1][j-P-:1];
      assign s_0[i][j-P-:P] = s_0[i-1][j-P-:P];
      assign c_0[i][j-P-:1] = c_0[i-1][j-P-:1];

    end
  end
  assign {c_o, s_o} = {c_1[NS][W-1], s_1[NS]};

endmodule
