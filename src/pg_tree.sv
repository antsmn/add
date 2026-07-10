module pg_tree #(
    parameter W = 8
) (
    input  logic [W-1:0] p_i,
    input  logic [W-1:0] g_i,
    output logic [W-1:0] p_o,
    output logic [W-1:0] g_o
);
  always @(*) begin
    g_o = g_i;
    p_o = p_i;
    for (int i = 1; i < W; i = i + 1) {g_o[i], p_o[i]} = {g_o[i] | p_o[i] & g_o[i-1], p_o[i] & p_o[i-1]};
  end

endmodule
