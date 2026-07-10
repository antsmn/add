module pg_rca #(
    parameter W = 4
) (
    input  logic         c_i,
    input  logic [W-1:0] p_i,
    input  logic [W-1:0] g_i,
    output logic [W-1:0] s_o,
    output logic         c_o
);
  logic [W-1:0] g;

  assign {c_o, g} = {g_i | (p_i & g), c_i};
  assign s_o = p_i ^ g;

endmodule
