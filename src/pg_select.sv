module pg_select #(
    parameter W = 4
) (
    input  logic [W-1:0] p_i,
    input  logic [W-1:0] g_i,
    input  logic         c_i,
    output logic [W-1:0] s_o,
    output logic         c_o
);
  logic [1:0][W-1:0] s;
  logic [1:0]        c;

  pg_rca #(.W(W)) i_rca_1 (.p_i(p_i), .g_i(g_i), .c_i(1'b0), .s_o(s[0]), .c_o(c[0]));
  pg_rca #(.W(W)) i_rca_2 (.p_i(p_i), .g_i(g_i), .c_i(1'b1), .s_o(s[1]), .c_o(c[1]));

  assign {c_o, s_o} = c_i ? {c[1], s[1]} : {c[0], s[0]};

endmodule
