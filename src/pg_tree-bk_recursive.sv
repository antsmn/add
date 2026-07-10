module pg_tree #(
    parameter W = 32,
    parameter R = 2    // fixed for now
) (
    input  logic [W-1:0] p_i,
    input  logic [W-1:0] g_i,
    output logic [W-1:0] p_o,
    output logic [W-1:0] g_o
);
  if (W == 1) begin
    assign g_o = g_i;
    assign p_o = p_i;
  end else if (W == R) begin
    pg #(
        .W(2)
    ) i_pg (
        .p_i(p_i),
        .g_i(g_i),
        .p_o(p_o[1]),
        .g_o(g_o[1])
    );
    assign g_o[0] = g_i[0];
    assign p_o[0] = p_i[0];

  end else begin

    localparam WIDTH = W / 2;

    logic [WIDTH-1:0] ep;
    logic [WIDTH-1:0] eg;
    logic [WIDTH-1:0] op;
    logic [WIDTH-1:0] og;

    for (genvar i = 0; i < WIDTH; i += 1) begin
      assign {op[i], ep[i]} = p_i[i*2+:2];
      assign {og[i], eg[i]} = g_i[i*2+:2];
    end

    logic [WIDTH-1:0] op2;
    logic [WIDTH-1:0] og2;
    logic [WIDTH-1:0] op3;
    logic [WIDTH-1:0] og3;

    for (genvar i = 0; i < WIDTH; i += 1) begin
      wire [1:0] op1 = {op[i], ep[i]};
      wire [1:0] og1 = {og[i], eg[i]};

      pg #(
          .W(2)
      ) i_pg (
          .p_i(op1),
          .g_i(og1),
          .p_o(op2[i]),
          .g_o(og2[i])
      );

    end

    // prefix sum W / 2

    pg_tree #(
        .W(WIDTH)
    ) i_pg_tree (
        .p_i(op2),
        .g_i(og2),
        .p_o(op3),
        .g_o(og3)
    );

    logic [WIDTH-1:0] ep2;
    logic [WIDTH-1:0] eg2;

    assign ep2[0] = ep[0];
    assign eg2[0] = eg[0];


    for (genvar i = 1; i < WIDTH; i += 1) begin
      wire [1:0] ep1 = {ep[i], op3[i-1]};
      wire [1:0] eg1 = {eg[i], og3[i-1]};

      pg #(
          .W(2)
      ) i_pg (
          .p_i(ep1),
          .g_i(eg1),
          .p_o(ep2[i]),
          .g_o(eg2[i])
      );

    end

    for (genvar i = 0; i < WIDTH; i += 1) begin
      assign p_o[i*2+:2] = {op3[i], ep2[i]};
      assign g_o[i*2+:2] = {og3[i], eg2[i]};
    end

  end

endmodule
