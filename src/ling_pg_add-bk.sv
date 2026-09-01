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

  logic [W-1:0] p_0;
  logic [W-1:0] g_0;
  logic [W-1:0] t_0;
  logic [W-1:0] h_0;
  logic [W-1:0] t_1;
  logic [W-1:0] h_1;

  assign h_0 = {g_0[W-2:0], c_i};
  assign t_0 = a_i | b_i;
  assign p_0 = a_i ^ b_i;
  assign g_0 = a_i & b_i;

  always @(*) begin
    for (int k = W - 1; k > 0; k -= 1) begin
      h_1[k] = h_0[k] | h_0[k-1];
    end
    h_1[0] = h_0[0];
    for (int k = W - 1; k > 2; k -= 1) begin
      t_1[k] = t_0[k-2] & t_0[k-3];
    end
    t_1[0] = 1'b0;
    t_1[1] = 1'b0;
    t_1[2] = t_0[0];

    for (int i = 2; i < NS + 1; i += 1) begin
      for (int k = 2 ** i - 1; k < W; k += 2 ** i) begin
        h_1[k] = h_1[k] | (t_1[k] & h_1[k-2**(i-1)]);
        t_1[k] = t_1[k] & t_1[k-2**(i-1)];
      end
    end
    for (int i = NS; i > 0; i -= 1) begin
      for (int k = 2 ** (i - 1) + 2 ** i - 1; k < W; k += 2 ** i) begin
        h_1[k] = h_1[k] | (t_1[k] & h_1[k-2**(i-1)]);
        t_1[k] = t_1[k] & t_1[k-2**(i-1)];
      end
    end
  end
  assign s_o = p_0 ^ (h_1 & ((t_0 << 1) | 1'b1));

  assign c_o = g_0[W-1] | (t_0[W-1] & (h_1[W-1] & t_0[W-2]));

endmodule
