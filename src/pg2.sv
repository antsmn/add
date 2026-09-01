module pg2 #(
  parameter W = 4
) (
  input  logic [W-1:0] p_i,
  input  logic [W-1:0] g_i,
  output logic [W-1:0] g_o,
  output logic [W-1:0] p_o
);

  for (genvar i = W - 1; i > 0; i -= 1)
  begin

    pg #(2) i_pg (.p_i({p_i[i], p_i[0]}), .g_i({g_i[i], g_i[0]}), .p_o(p_o[i]), .g_o(g_o[i]));

  end

  assign p_o[0] = p_i[0];
  assign g_o[0] = g_i[0];

endmodule
