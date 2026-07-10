`timescale 1ns / 1ns
module tb_abs_difference;
  parameter W = 32;
  logic [W-1:0] a_i;
  logic [W-1:0] b_i;
  logic [W-1:0] s_o;
  logic         c_o;

  logic [  W:0] res;
  logic [  W:0] sub;

  initial begin
    $dumpfile("tb_abs_difference");
    $dumpvars(0, tb_abs_difference);
    a_i = 0;
    b_i = 0;
    repeat (1 << 10) begin
      a_i = $random();
      b_i = $random();
      #1
      assert ({c_o, s_o} == res)
      else begin
        $fatal(1, "%b", {c_o, s_o} - res);
      end
    end
  end

  pg_abs_difference #(.W(W)) DUT (.*);

  assign sub = a_i - b_i;
  assign res = $signed(sub) > 0 ? sub : -sub;

endmodule
