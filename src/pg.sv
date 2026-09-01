module pg #(
  parameter W = 4
) (
  input  logic [W-1:0] p_i,
  input  logic [W-1:0] g_i,
  output logic         p_o,
  output logic         g_o
);
  logic [W-1:0] p_0;
  logic [W-1:0] g_0;
  logic [W-1:0] g_1;

  assign g_1[W-1] = g_0[W-1];

  for (genvar i = W - 1; i > 0; i -= 1)
  begin

    assign g_1[i-1] = &p_0[W-1:i] & g_0[i-1];

  end

  assign p_0 = p_i;
  assign g_0 = g_i;
  assign g_o = |g_1;
  assign p_o = &p_0;

endmodule
