module pg_tree #(
  parameter W = 32,
  parameter R = 2
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
    pg1 #(
      .W(R)
    ) i_pg1 (
      .p_i(p_i),
      .g_i(g_i),
      .p_o(p_o),
      .g_o(g_o)
    );

  end else begin

    localparam WIDTH = 2 ** $clog2(W);
    localparam H = W - WIDTH / 2;
    localparam L = WIDTH / 2;

    logic [H-1:0] hp;
    logic [H-1:0] hg;
    logic [L-1:0] lp;
    logic [L-1:0] lg;
    logic [H-1:0] hp1;
    logic [H-1:0] hg1;
    logic [L-1:0] lp1;
    logic [L-1:0] lg1;

    assign lp = p_i[0+:L];
    assign lg = g_i[0+:L];
    assign hp = p_i[L+:H];
    assign hg = g_i[L+:H];

    pg_tree #(
      .W(H)
    ) i_pg_tree_H (
      .p_i(hp),
      .g_i(hg),
      .p_o(hp1),
      .g_o(hg1)
    );
    pg_tree #(
      .W(L)
    ) i_pg_tree_L (
      .p_i(lp),
      .g_i(lg),
      .p_o(lp1),
      .g_o(lg1)
    );

    logic [H-1:0] hg2;
    logic [H-1:0] hp2;

    for (genvar i = H - 1; i > -1; i -= 1) begin : w
      logic [1:0] p;
      logic [1:0] g;
      assign p = {hp1[i], lp1[L-1]};
      assign g = {hg1[i], lg1[L-1]};

      logic po;
      logic go;

      pg #(
        .W(2)
      ) i_pg (
        .p_i(p),
        .g_i(g),
        .p_o(po),
        .g_o(go)
      );
      assign hp2[i] = po;
      assign hg2[i] = go;

    end
    assign g_o = {hg2[0+:(H)], lg1};
    assign p_o = {hp2[0+:(H)], lp1};

  end

endmodule
