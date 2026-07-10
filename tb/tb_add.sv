// `timescale 1ns / 1ns
module tb_add;
  parameter W = 32;

  logic [W-1:0] a_i;
  logic [W-1:0] b_i;
  logic         c_i;
  logic         c_o;
  logic [W-1:0] s_o;

  logic [  W:0] res;
  logic [  W:0] diff;
  logic         error;

  initial begin
    $dumpfile("tb_add");
    $dumpvars(0, tb_add);
    a_i = 0;
    b_i = 0;
    c_i = 0;
    repeat (1 << 10) begin
      a_i = $random();
      b_i = $random();
      c_i = $random();
      #1
      assert (!error)
      else begin
        $fatal(1, "%b %b %b %b %b", a_i, b_i, c_i, diff, res);
      end
    end
  end
`ifdef NETLIST
  initial $sdf_annotate(`SDF_FILENAME, DUT);
  pg_add DUT (.*);

`else
  pg_add #(.W(W)) DUT (.*);

`endif

  assign res   = a_i + b_i + c_i;
  assign diff  = res - {c_o, s_o};
  assign error = res != {c_o, s_o};

endmodule
