module pg_add #(
  parameter W = 32
) (
  input  logic [W-1:0] a_i,
  input  logic [W-1:0] b_i,
  input  logic         c_i,
  output logic [W-1:0] s_o,
  output logic         c_o
);
  logic [W-1:0] p_0;
  logic [W-1:0] g_0;
  logic [W-5:0] p_1;
  logic [W-5:0] g_1;
  logic [W-5:0] g_2;

  logic [W-4:0] g_3;
  logic [W-1:0] g_4;

  assign p_0 = (a_i ^ b_i);
  assign g_0 = (a_i & b_i) | p_0 & c_i;

  assign p_1 = p_0[W-5:0];
  assign g_1 = g_0[W-5:0];

  pg_tree #(.W(W - 4)) i_pg_tree (.p_i(p_1), .g_i(g_1), .g_o(g_2), .p_o());

  assign g_3 = g_2 << 1 | c_i;

  for (genvar i = 3; i < W; i += 4) begin

    logic [3:0] so;
    logic       co;

    pg_select #(.W(4)) i_pg_select (.p_i(p_0[i-:4]), .g_i(g_0[i-:4]), .c_i(g_3[i-3]), .c_o(co), .s_o(so));
    assign g_4[i] = co;
    assign s_o[i-:4] = so;

  end

  assign c_o = g_4[W-1];

endmodule
