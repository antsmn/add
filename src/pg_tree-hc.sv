module pg_tree #(
    parameter W = 32,
    parameter R = 4
) (
    input  logic [W-1:0] p_i,
    input  logic [W-1:0] g_i,
    output logic [W-1:0] p_o,
    output logic [W-1:0] g_o
);

  localparam int NS = $ceil($ln(W) / $ln(R));
  localparam int NW = R ** NS;

  logic [NS:0][NW-1:0] p_0;
  logic [NS:0][NW-1:0] g_0;
  logic [ 1:0][NW-1:0] p_1;
  logic [ 1:0][NW-1:0] g_1;

  assign p_o = p_1[1][W-1:0];
  assign g_o = g_1[1][W-1:0];

  assign p_0[0] = p_i;
  assign g_0[0] = g_i;

  genvar i;
  genvar k;

  for (k = R - 1; k < (W + R); k += R)
  begin : gen_bk
    pg1 #(.W(R)) i_pg1 (.p_i(p_0[0][k-:R]), .g_i(g_0[0][k-:R]), .p_o(p_0[1][k-:R]), .g_o(g_0[1][k-:R]));
  end
  for (i = 1; i < NS; i += 1)
  begin : gen_ks

    localparam K = R ** i;

    assign p_0[i+1][K-1:0] = p_0[i][K-1:0];
    assign g_0[i+1][K-1:0] = g_0[i][K-1:0];

    for (k = (R) + K - 1; k < (W + R); k += R)
    begin : gen_pg

      logic [  k:0] p;
      logic [  k:0] g;
      logic [R-1:0] pi;
      logic [R-1:0] gi;
      logic         po;
      logic         go;

      assign p = p_0[i][k:0];
      assign g = g_0[i][k:0];

      pg #(.W(R)) i_pg (.p_i(pi), .g_i(gi), .p_o(po), .g_o(go));

      ext #(.W(k + 1), .R(R), .P(K)) i_ext_p (.p_i(p), .p_o(pi));
      ext #(.W(k + 1), .R(R), .P(K)) i_ext_g (.p_i(g), .p_o(gi));

      assign p_0[i+1][k-:R] = {po, p_0[i][k-1-:(R-1)]};
      assign g_0[i+1][k-:R] = {go, g_0[i][k-1-:(R-1)]};

    end

  end

  assign p_1[0] = p_0[NS];
  assign g_1[0] = g_0[NS];

  for (k = (R - 1) + R - 1; k < (W + R); k += R)
  begin : gen_bk2

    pg2 #(.W(R)) i_pg2 (.p_i(p_1[0][k-:R]), .g_i(g_1[0][k-:R]), .p_o(p_1[1][k-:R]), .g_o(g_1[1][k-:R]));

  end
  assign p_1[1][R-2:0]   = p_1[0][R-2:0];
  assign g_1[1][R-2:0]   = g_1[0][R-2:0];
  assign p_1[1][NW-1-:1] = p_1[0][NW-1-:1];
  assign g_1[1][NW-1-:1] = g_1[0][NW-1-:1];

endmodule
