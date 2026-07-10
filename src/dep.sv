module dep #(
    parameter W = 8,
    parameter R = 4,
    parameter P = 2
) (
    input  logic [R-1:0] a_i,
    input  logic [W-1:0] p_i,
    output logic [W-1:0] p_o
);
  // may be function
  always @(*) begin
    p_o = p_i;
    for (int i = 0; i < R; i += 1) p_o[W-1-i*P] = a_i[R-1-i];
  end
endmodule
