module pg_tree #(
    parameter W = 32,
    parameter R = 2
) (
    input  logic [W-1:0] p_i,
    input  logic [W-1:0] g_i,
    output logic [W-1:0] p_o,
    output logic [W-1:0] g_o
);
  localparam int NS = $ceil($ln(W) / $ln(R));
  localparam int NW = R ** NS;

  logic [  NS:0][NW-1:0] p_0;
  logic [  NS:0][NW-1:0] g_0;
  logic [NS-1:0][NW-1:0] p_1;
  logic [NS-1:0][NW-1:0] g_1;

  assign p_o = p_1[0][W-1:0];
  assign g_o = g_1[0][W-1:0];

  assign p_0[0] = p_i;
  assign g_0[0] = g_i;

  genvar                 i;
  genvar                 k;

  for (i = 1; i < NS + 1; i += 1)
  begin : gen_bk
    localparam P = R ** (i - 1);
    localparam K = R ** i;
    for (k = K - 1; k < NW; k += K)
    begin : gen_pg

      pg_bk1 #(.W(K), .P(P), .R(R)) i_pg_bk1 (.p_i(p_0[i-1][k-:K]), .g_i(g_0[i-1][k-:K]), .p_o(p_0[i][k-:K]), .g_o(g_0[i][k-:K]));
    end
  end
  // carry reverse tree
  assign p_1[NS-1] = p_0[NS];
  assign g_1[NS-1] = g_0[NS];

  for (i = NS - 1; i > 0; i -= 1)
  begin : gen_bk2
    localparam P = R ** (i - 1);  // prefix size
    localparam K = R ** i;  // group size
    localparam L = P * (R - 1);
    for (k = L + K - 1; k < NW; k += K)
    begin : gen_pg

      pg_bk2 #(.W(K), .P(P), .R(R)) i_pg_bk2 (.p_i(p_1[i][k-:K]), .g_i(g_1[i][k-:K]), .p_o(p_1[i-1][k-:K]), .g_o(g_1[i-1][k-:K]));

    end
    assign p_1[i-1][L-1:0]   = p_1[i][L-1:0];
    assign g_1[i-1][L-1:0]   = g_1[i][L-1:0];
    assign p_1[i-1][NW-1-:P] = p_1[i][NW-1-:P];
    assign g_1[i-1][NW-1-:P] = g_1[i][NW-1-:P];

  end

endmodule

module pg_bk1 #(
    parameter W,
    parameter R,
    parameter P
) (
    input  logic [W-1:0] p_i,
    input  logic [W-1:0] g_i,
    output logic [W-1:0] p_o,
    output logic [W-1:0] g_o
);
  // P = 1 degenerates to pg1: ext = p_i[W-1-:R] dep = p_o[W-1-:R]
  logic [R-1:0] p_1;
  logic [R-1:0] g_1;
  logic [R-1:0] p_2;
  logic [R-1:0] g_2;

  pg1 #(.W(R)) i_pg1 (.p_i(p_1), .g_i(g_1), .p_o(p_2), .g_o(g_2));

  dep #(.W(W), .R(R), .P(P)) i_dep_p (.a_i(p_2), .p_i(p_i), .p_o(p_o));
  dep #(.W(W), .R(R), .P(P)) i_dep_g (.a_i(g_2), .p_i(g_i), .p_o(g_o));
  ext #(.W(W), .R(R), .P(P)) i_ext_p (.p_i(p_i), .p_o(p_1));
  ext #(.W(W), .R(R), .P(P)) i_ext_g (.p_i(g_i), .p_o(g_1));

endmodule

module pg_bk2 #(
    parameter W,
    parameter R,
    parameter P
) (
    input  logic [W-1:0] p_i,
    input  logic [W-1:0] g_i,
    output logic [W-1:0] p_o,
    output logic [W-1:0] g_o
);
  logic [R-1:0] p_1;
  logic [R-1:0] g_1;
  logic [R-1:0] g_2;

  pg2 #(.W(R)) i_pg2 (.p_i(p_1), .g_i(g_1), .g_o(g_2), .p_o());

  assign p_o = p_i;
  dep #(.W(W), .R(R), .P(P)) i_dep_g (.a_i(g_2), .p_i(g_i), .p_o(g_o));
  ext #(.W(W), .R(R), .P(P)) i_ext_p (.p_i(p_i), .p_o(p_1));
  ext #(.W(W), .R(R), .P(P)) i_ext_g (.p_i(g_i), .p_o(g_1));

endmodule
