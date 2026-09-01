`default_nettype none
<% h, w = array.shape %>
module ${name} (
  input  logic [${w-1}:0] p_i,
  input  logic [${w-1}:0] g_i,
  output logic [${w-1}:0] p_o,
  output logic [${w-1}:0] g_o
);
% for i in range(h + 1):
  logic [${w-1}:0] p_${i};
  logic [${w-1}:0] g_${i};
% endfor

  assign g_o = g_${h};
  assign p_o = p_${h};
  assign p_0 = p_i;
  assign g_0 = g_i;

% for i, s in enumerate(array):

  // stage ${i}

% for k, v in enumerate(s):
% if v:

  pg #(2) i_pg_${i+1}_${k} (.p_i({{ p_${i}[${k}], p_${i}[${v-1}] }}), .g_i({{ g_${i}[${k}], g_${i}[${v-1}] }}), .p_o(p_${i+1}[${k}]), .g_o(g_${i+1}[${k}]));

% else:

  assign g_${i+1}[${k}] = g_${i}[${k}];
  assign p_${i+1}[${k}] = p_${i}[${k}];

% endif
% endfor
% endfor

endmodule
