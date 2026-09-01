module carry_select_rca #(
  parameter int W = 16,
  parameter int K = 4
) (
  input  logic [W-1:0] a_i,
  input  logic [W-1:0] b_i,
  input  logic         c_i,
  output logic [W-1:0] s_o,
  output logic         c_o
);
  if (W == K) begin

    logic [W-1:0] p_0;
    logic [W-1:0] g_0;

    assign p_0 = a_i ^ b_i;
    assign g_0 = a_i & b_i;
    pg_rca #(.W(K)) i_pg_rca (.c_i(c_i), .p_i(p_0), .g_i(g_0), .s_o(s_o), .c_o(c_o));

  end else begin

    localparam H = W / 2;

    logic [1:0][H-1:0] a_0;
    logic [1:0][H-1:0] b_0;
    logic [1:0][H-1:0] s_0;
    logic [1:0] c_0;
    logic c_1;

    assign a = a_i;
    assign b = b_i;

    carry_select_rca #(.W(H), .K(K)) i_carry_select_rca_0 (.c_i(c_i), .a_i(a[0]), .b_i(b[0]), .s_o(s_o[H-1:0]), .c_o(c_1));

    carry_select_rca #(.W(H), .K(K)) i_carry_select_rca_1 (.c_i(1'b0), .a_i(a[1]), .b_i(b[1]), .s_o(s_0[0]), .c_o(c_0[0]));
    carry_select_rca #(.W(H), .K(K)) i_carry_select_rca_2 (.c_i(1'b1), .a_i(a[1]), .b_i(b[1]), .s_o(s_0[1]), .c_o(c_0[1]));

    // assign {c_o, s_o[H+:H]} = c_1 ? {c_0[1], s_0[1]} : {c_0[0], s_0[0]};
    mux2 #(.W(1 + H)) i_mux2 (.s(c_1), .z({c_o, s_o[H+:H]}), .a({c_0[0], s_0[0]}), .b({c_0[1], s_0[1]}));

  end

endmodule
