module pg_add #(
    parameter int W = 8,
    parameter int K = 4
) (
    input  logic [W-1:0] a_i,
    input  logic [W-1:0] b_i,
    input  logic         c_i,
    output logic [W-1:0] s_o,
    output logic         c_o
);
  localparam NS = $clog2(W);
  localparam NW = 2 ** NS;
  // assert W and K power of 2 for sklansky sparse K

  logic [NW-1:0] p_0;
  logic [NW-1:0] g_0;
  logic [NW-1:0] h_0;
  logic [NW-1:0] t_0;
  logic [NW-1:0] t_1;
  logic [NW-1:0] h_1;
  logic [NW-1:0] s_1;

  // local carry and conditional sum
  logic [NW-1:0] lh_0;
  logic [NW-1:0] lh_1;
  logic [NW-1:0] ls_0;
  logic [NW-1:0] ls_1;

  always @(*) begin
    p_0 = a_i ^ b_i;
    g_0 = a_i & b_i;

    h_0 = {g_0[W-2:0], c_i};
    t_0 = a_i | b_i;

    for (int k = W - 1; k > 0; k -= 1) begin
      h_1[k] = h_0[k] | h_0[k-1];
    end
    h_1[0] = h_0[0];

    for (int k = W - 1; k > 2; k -= 1) begin
      t_1[k] = t_0[k-2] & t_0[k-3];
    end
    t_1[0] = 1'b0;
    t_1[1] = 1'b0;
    t_1[2] = t_0[0];

    for (int i = 2; i < NS + 1; i += 1) begin
      for (int j = 2 ** i - 1; j < NW; j += 2 ** i) begin
        // guard carry tree gen at msb, sparse K sklansky split loop to handle shifted nodes for ling carries selects
        if (j < W) begin

          h_1[j] = h_1[j] | t_1[j] & h_1[j-2**(i-1)];
          t_1[j] = t_1[j] & t_1[j-2**(i-1)];
        end
        for (int k = j - K + 1; k > j - 2 ** (i - 1); k -= K) begin
          if (k < W) begin

            h_1[k] = h_1[k] | t_1[k] & h_1[j-2**(i-1)];
            t_1[k] = t_1[k] & t_1[j-2**(i-1)];
          end
        end
      end
    end
    lh_0[0] = c_i;

    for (int k = 1; k < K; k += 1) begin
      lh_0[k] = g_0[k-1] | t_0[k-1] & lh_0[k-1];
    end
    // generate lh_0[K-1:0] = {g_0[K-2:0] | (t_0[K-2:0] & lh_0[K-2:0]), c_i};

    s_1[K-1:0] = p_0[K-1:0] ^ lh_0[K-1:0];

    for (int i = K; i < NW; i += K) begin
      lh_0[i] = 1'b0;
      for (int k = i + 1; k < i + K; k += 1) begin
        lh_0[k] = g_0[k-1] | t_0[k-1] & lh_0[k-1];
      end
      lh_1[i] = t_0[i-1];
      for (int k = i + 1; k < i + K; k += 1) begin
        lh_1[k] = g_0[k-1] | t_0[k-1] & lh_1[k-1];
      end
      for (int k = i; k < i + K; k += 1) begin
        ls_0[k] = p_0[k] ^ lh_0[k];
      end
      for (int k = i; k < i + K; k += 1) begin
        ls_1[k] = p_0[k] ^ lh_1[k];
      end
      // lh_0[i+:K] = {g_0[i+:(K-1)] | (t_0[i+:(K-1)] & lh_0[i+:(K-1)]), 1'b0};
      // lh_1[i+:K] = {g_0[i+:(K-1)] | (t_0[i+:(K-1)] & lh_1[i+:(K-1)]), t_0[i-1]};
      // ls_0[i+:K] = (p_0[i+:K] ^ lh_0[i+:K]);
      // ls_1[i+:K] = (p_0[i+:K] ^ lh_1[i+:K]);

      s_1[i+:K] = h_1[i] ? ls_1[i+:K] : ls_0[i+:K];
    end
  end
  assign s_o = s_1[W-1:0];

  assign c_o = g_0[W-1] | t_0[W-1] & (h_1[W-1] & t_0[W-2]);

endmodule
