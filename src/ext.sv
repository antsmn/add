module ext #(
    parameter W = 8,
    parameter R = 4,
    parameter P = 2
) (
    input  logic [W-1:0] p_i,
    output logic [R-1:0] p_o
);
  // may be function
  always @(*) begin
    p_o = '0;
    for (int i = 0; i < R; i += 1) if (i * P < W) p_o[R-1-i] = p_i[W-1-i*P];
  end
endmodule
