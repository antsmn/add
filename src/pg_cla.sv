module pg_add #(
  parameter W = 32
) (
  input  logic [W-1:0] a_i,
  input  logic [W-1:0] b_i,
  input  logic         c_i,
  output logic [W-1:0] s_o,
  output logic         c_o
);

  localparam NS = $clog2(W);
  localparam NW = 2 ** NS;

  logic [NS:0][NW-1:0] p_0;
  logic [NS:0][NW-1:0] g_0;
  logic [NS:0][NW-1:0] c_0;

  for (genvar i = 1; i < NS + 1; i += 1) begin

    localparam P = 2 ** (i - 1);
    localparam K = 2 ** i;

    for (genvar k = K - 1; k < NW; k += K) begin // PGEN

      logic [1:0] p;
      logic [1:0] g;
      assign p = {p_0[i-1][k], p_0[i-1][k-P]};
      assign g = {g_0[i-1][k], g_0[i-1][k-P]};
      logic       po;
      logic       go;
      pg #(.W(2)) i_pg (.p_i(p), .g_i(g), .p_o(po), .g_o(go));

      assign p_0[i][k] = po;
      assign g_0[i][k] = go;

    end


    for (genvar k = P    ; k < NW; k += K) begin // CGEN

      logic [1:0] p;
      logic [1:0] g;
      assign p = {p_0[i-1][k-1], c_0[i][k-P]};
      assign g = {g_0[i-1][k-1], c_0[i][k-P]};
      logic       po;
      logic       go;
      pg #(.W(2)) i_pg (.p_i(p), .g_i(g), .p_o(po), .g_o(go));

      assign c_0[i-1][k]   = go;
      assign c_0[i-1][k-P] = c_0[i][k-P];

    end
  end

  logic [NW-1:0] p_1;
  logic [NW-1:0] g_1;
  logic [NW-1:0] c_1;

  assign p_1 = p_0[0];
  assign g_1 = g_0[0];
  assign c_1 = c_0[0];

  logic [NW-1:0] p_2;
  logic [NW-1:0] g_2;

  assign p_2 = p_0[NS];
  assign g_2 = g_0[NS];

  if (W == NW) begin
    assign c_o = g_2[W-1] | p_2[W-1] & c_i;
  end else begin
    assign c_o = g_1[W-1] | p_1[W-1] & c_1[W-1];
  end

  assign s_o = p_1[W-1:0] ^ c_1[W-1:0];

  assign c_0[NS][0] = c_i;
  assign p_0[0] = a_i ^ b_i;
  assign g_0[0] = a_i & b_i;

endmodule
