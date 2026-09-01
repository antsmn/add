module pg_fpa #(
  parameter W = 32
) (
  input  logic         v_i,  // !b
  input  logic         n_i,  // neg
  input  logic         c_i,  // inc
  input  logic [W-1:0] a_i,
  input  logic [W-1:0] b_i,
  output logic [W-1:0] s_o,
  output logic         c_o
);
  logic [W-1:0] p_0;
  logic [W-1:0] g_0;
  logic [W-1:0] p_1;
  logic [W-1:0] g_1;
  logic [  W:0] p_2;
  logic [  W:0] g_2;

  // !b means inverting flagged bits decrements rather than increments

  assign p_0 = a_i ^ (b_i ^ ({W{v_i}}));
  assign g_0 = a_i & (b_i ^ ({W{v_i}}));

  pg_tree #(.W(W)) i_pg_tree (.p_i(p_0), .g_i(g_0), .p_o(p_1), .g_o(g_1));

  // can use nk = a | b in pg tree then mask is g | nk

  assign p_2 = p_1 << 1 | 1'b1;  // mask for trailing 1
  assign g_2 = g_1 << 1;

  // negate unflagged bits or negate flagged bits (increment)

  logic [  W:0] mask;

  assign mask = (~p_2 & ({(W + 1) {n_i}})) | (p_2 & ({(W + 1) {c_i}}));

  assign {c_o, s_o} = {v_i, p_0} ^ g_2 ^ mask;

endmodule
