from collections.abc import Callable
from math import ceil, log2

import numpy as np
from mako.template import Template

np.set_printoptions(threshold=1000, linewidth=1000)

__all__ = [
    "ARCHITECTURES",
    "render",
    "sklansky",
    "brent_kung",
    "kogge_stone",
    "han_carlson",
    "han_carlson_v2",
    "ladner_fischer",
]


def clog2(w: int) -> int:
    return ceil(log2(w))


def npow2(w: int) -> int:
    return 2 ** clog2(w)


def ks_gen(i, w, s=1):
    for k in range(w - 1, 2 ** (i) - 1, -s):
        yield (k, k - 2 ** (i))


def bk_gen1(i, w):
    for k in range(2 ** (i) - 1, w, 2 ** (i)):
        yield (k, k - 2 ** (i - 1))


def bk_gen2(i, w):
    """`bk_gen1` shifted to even digits at stage `i`"""
    for k in range(2 ** (i - 1) + 2 ** (i) - 1, w, 2 ** (i)):
        yield (k, k - 2 ** (i - 1))


def sk_gen(i, w, s=1):
    for j in range(2 ** (i) - 1, w, 2 ** (i)):
        for k in range(j, j - 2 ** (i - 1), -s):
            yield (k, j - 2 ** (i - 1))


def sklansky(w: int) -> np.ndarray:
    ns = clog2(w)
    nw = npow2(w)

    a = np.zeros((ns, nw), dtype=int)
    for i in range(1, ns + 1):
        for k, p in sk_gen(i, nw):
            a[i - 1, k] = p + 1

    return a[:, :w]


def brent_kung(w: int) -> np.ndarray:
    ns = clog2(w)
    nw = npow2(w)

    a = np.zeros((2 * ns - 1, nw), dtype=int)
    for s, i in enumerate(range(1, ns + 1)):
        for k, p in bk_gen1(i, nw):
            a[s, k] = p + 1
    for s, i in enumerate(range(ns - 1, 0, -1), start=ns):
        for k, p in bk_gen2(i, nw):
            a[s, k] = p + 1

    return a[:, :w]


def kogge_stone(w: int) -> np.ndarray:
    ns = clog2(w)

    a = np.zeros((ns, w), dtype=int)
    for i in range(ns):
        for k, p in ks_gen(i, w):
            a[i, k] = p + 1

    return a


def han_carlson(w: int) -> np.ndarray:
    ns = clog2(w)
    nw = npow2(w)

    a = np.zeros((ns + 1, nw), dtype=int)
    for i in range(ns):
        for k, p in ks_gen(i, nw, 2):
            a[i, k] = p + 1
    for k, p in bk_gen2(1, nw):
        a[ns, k] = p + 1

    return a[:, :w]


def han_carlson_v2(w: int) -> np.ndarray:
    ns = clog2(w)
    nw = npow2(w)

    a = np.zeros((ns + 2, nw), dtype=int)
    for k, p in bk_gen1(1, nw):
        a[0, k] = p + 1
    for k, p in bk_gen1(2, nw):
        a[1, k] = p + 1
    for i in range(2, ns + 1):
        for k, p in ks_gen(i, nw, 4):
            a[i, k] = p + 1
    for k, p in bk_gen2(2, nw):
        a[ns, k] = p + 1
    for k, p in bk_gen2(1, nw):
        a[ns + 1, k] = p + 1

    return a[:, :w]


def ladner_fischer(w: int) -> np.ndarray:
    ns = clog2(w)
    nw = npow2(w)

    a = np.zeros((ns + 1, nw), dtype=int)
    for i in range(ns):
        for k, p in sk_gen(i + 1, nw, 2):
            a[i, k] = p + 1
    for k, p in bk_gen2(1, w):
        a[ns, k] = p + 1

    return a[:, :w]


def render(a: np.ndarray, w: int, name: str = "pg_tree") -> str:
    return Template(VLOG_TEMPLATE).render(a=a, w=w, name=name)


VLOG_TEMPLATE: str = """\
module ${name} #(
    parameter W = ${w}
) (
    input  logic [${w-1}:0] p_i,
    input  logic [${w-1}:0] g_i,
    output logic [${w-1}:0] p_o,
    output logic [${w-1}:0] g_o
);
% for i in range(a.shape[0] + 1):
  logic [${w-1}:0] p_${i};
  logic [${w-1}:0] g_${i};
% endfor
  assign g_o = g_${a.shape[0]};
  assign p_o = p_${a.shape[0]};
  assign p_0 = p_i;
  assign g_0 = g_i;
% for i, s in enumerate(a):
  // stage ${i}
% for k, x in enumerate(s[:w]):
% if x:
  pg #(2) i_pg_${i+1}_${k} (.p_i({{p_${i}[${k}],p_${i}[${x-1}]}}), .g_i({{g_${i}[${k}],g_${i}[${x-1}]}}), \
.p_o(p_${i+1}[${k}]), .g_o(g_${i+1}[${k}]));
% endif
% endfor
% endfor
% for i, s in enumerate(a):
  // stage ${i}
% for k, x in enumerate(s[:w]):
% if not x:
  assign g_${i+1}[${k}] = g_${i}[${k}];
  assign p_${i+1}[${k}] = p_${i}[${k}];
% endif
% endfor
% endfor
endmodule
"""

# assign g_${i+1}[${k}] = g_${i}[${k}] | (p_${i}[${k}] & g_${i}[${x-1}]);
# assign p_${i+1}[${k}] = p_${i}[${k}] & (p_${i}[${x-1}]);


ARCHITECTURES: dict[str, tuple[Callable[[int], np.ndarray], str]] = {
    "sk": (sklansky, "Sklansky"),
    "bk": (brent_kung, "Brent-Kung"),
    "ks": (kogge_stone, "Kogge-Stone"),
    "hc": (han_carlson, "Han-Carlson 1"),
    "hc2": (han_carlson_v2, "Han-Carlson 2"),
    "lf": (ladner_fischer, "Ladner-Fischer"),
}
