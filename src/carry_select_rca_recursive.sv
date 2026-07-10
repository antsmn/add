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

    pg_rca #(
        .W(K)
    ) i_pg_rca (
        .c_i(c_i),
        .p_i(p_0),
        .g_i(g_0),
        .s_o(s_o),
        .c_o(c_o)
    );

  end else begin

    localparam WIDTH = W / 2;

    logic [1:0][WIDTH-1:0] s_0;
    logic [1:0]            c_0;
    logic                  c_1;

    carry_select_rca #(
        .W(WIDTH),
        .K(K)
    ) i_carry_select_rca_0 (
        .a_i(a_i[WIDTH-1:0]),
        .b_i(b_i[WIDTH-1:0]),
        .c_i(c_i),
        .s_o(s_o[WIDTH-1:0]),
        .c_o(c_1)
    );
    carry_select_rca #(
        .W(WIDTH),
        .K(K)
    ) i_carry_select_rca_1 (
        .a_i(a_i[WIDTH+:WIDTH]),
        .b_i(b_i[WIDTH+:WIDTH]),
        .c_i(1'b0),
        .s_o(s_0[0]),
        .c_o(c_0[0])
    );
    carry_select_rca #(
        .W(WIDTH),
        .K(K)
    ) i_carry_select_rca_2 (
        .a_i(a_i[WIDTH+:WIDTH]),
        .b_i(b_i[WIDTH+:WIDTH]),
        .c_i(1'b1),
        .s_o(s_0[1]),
        .c_o(c_0[1])
    );
    MUX2_X1_W #(1 + WIDTH) i_MUX2_W (
        .Z({c_o, s_o[WIDTH+:WIDTH]}),
        .S(c_1),
        .A({c_0[0], s_0[0]}),
        .B({c_0[1], s_0[1]})
    );

    // assign {c_o, s_o[WIDTH+:WIDTH]} = c_1 ? {c_0[1], s_0[1]} : {c_0[0], s_0[0]};

  end

endmodule
