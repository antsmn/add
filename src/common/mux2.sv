module mux2 (A, B, S, Z);
  parameter W = 1;
  input   [W-1:0] A;
  input   [W-1:0] B;
  input           S;
  output  [W-1:0] Z;
  genvar          i;
  for (i = 0; i < W; i += 1)
  begin : w
    MUX2_X1 i_MUX_X1 (.A(A[i]), .B(B[i]), .S(S), .Z(Z[i]));
  end
endmodule

(*blackbox*)
module MUX2_X1 (A, B, S, Z);
  input         A;
  input         B;
  input         S;
  output        Z;
  wire          i_12;
  wire          i_13;
  wire          i_14;
  or(Z, i_12, i_13);
  and(i_12, S, B);
  and(i_13, A, i_14);
  not(i_14, S);
endmodule
