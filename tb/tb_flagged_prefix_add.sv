`timescale 1ns / 1ns
module tb_flagged_prefix_add;
  parameter W = 32;
  logic         v_i;  //!b
  logic         n_i;  //neg
  logic         c_i;  //inc
  logic [W-1:0] a_i;
  logic [W-1:0] b_i;
  logic [W-1:0] s_o;
  logic         c_o;

  logic [  W:0] res;

  initial begin
    $dumpfile("tb_flagged_prefix_add");
    $dumpvars(0, tb_flagged_prefix_add);
    v_i = 1'b0;
    n_i = 1'b0;
    c_i = 1'b0;
    a_i = 0;
    b_i = 0;
    repeat (1 << 10) begin
      v_i = $random();
      n_i = $random();
      c_i = $random();
      a_i = $random();
      b_i = $random();
      #1
      assert ({c_o, s_o} == res)
      else begin
        $fatal(1, "%b", {c_o, s_o} - res);
      end
    end
  end
  // Neil Burgess "Packed arithmetic on a prefix adder (PAPA)"
  pg_flagged_prefix_add #(.W(W)) DUT (.*);

  // 1s complement of value A is -(A + 1)

  // sum = A + B -> 1s complement of sum is -(A + B + 2), then sum is incremented usign trailing 1 prediction if c_i = 1
  // v2

  assign res = v_i ? (n_i ? (b_i  - a_i) - 1 + c_i : (a_i - b_i) - 1 + c_i) : (n_i ? -a_i - b_i - 2 + c_i : a_i + b_i + c_i);

endmodule
