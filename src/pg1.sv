module pg1 #(
    parameter W = 4
) (
    input  logic [W-1:0] p_i,
    input  logic [W-1:0] g_i,
    output logic [W-1:0] p_o,
    output logic [W-1:0] g_o
);
  for (genvar i = 1; i < W; i += 1)
  begin : w
    pg #(.W(i + 1)) i_pg (.p_i(p_i[i:0]), .g_i(g_i[i:0]), .p_o(p_o[i]), .g_o(g_o[i]));
  end
  assign g_o[0] = g_i[0];
  assign p_o[0] = p_i[0];

endmodule
