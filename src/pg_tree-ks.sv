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

  logic [NS:0][W-1:0] p_0;
  logic [NS:0][W-1:0] g_0;

  assign p_o = p_0[NS][W-1:0];
  assign g_o = g_0[NS][W-1:0];

  assign p_0[0] = p_i;
  assign g_0[0] = g_i;

  genvar i;
  genvar k;

  for (i = 0; i < NS; i += 1)
  begin : gen_ks

    localparam K = R ** i;

    assign p_0[i+1][K-1:0] = p_0[i][K-1:0];
    assign g_0[i+1][K-1:0] = g_0[i][K-1:0];

    for (k = K; k < W; k += 1)
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

      ext #(.W(k + 1), .R(R), .P(K)) i_ext_p(.p_i(p), .p_o(pi));
      ext #(.W(k + 1), .R(R), .P(K)) i_ext_g(.p_i(g), .p_o(gi));

      assign p_0[i+1][k] = po;
      assign g_0[i+1][k] = go;
      // IF SPARSE
      // assign p_0[i+1][k-:R] = {po, p_0[i][k-1-:(R-1)]};
      // assign g_0[i+1][k-:R] = {go, g_0[i][k-1-:(R-1)]};

    end

  end

endmodule
