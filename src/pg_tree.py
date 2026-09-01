import math
import numpy as np

np.set_printoptions(
    threshold=1000,
    linewidth=1000,
)


def clog2(width):
    return math.ceil(math.log2(width))


def npow2(width):
    return 2 ** clog2(width)


def ks_gen(width, stage, sparse=1):
    for k in range(width - 1, 2**stage - 1, -sparse):
        yield (k, k - 2**stage)


def sk_gen(width, stage, sparse=1):
    for j in range(2**stage - 1, width, 2**stage):
        for k in range(j, j - 2 ** (stage - 1), -sparse):
            yield (k, j - 2 ** (stage - 1))


def bk_gen1(width, stage):
    for k in range(2**stage - 1, width, 2**stage):
        yield (k, k - 2 ** (stage - 1))


def bk_gen2(width, stage):
    for k in range(2 ** (stage - 1) + 2**stage - 1, width, 2**stage):
        yield (k, k - 2 ** (stage - 1))


def kogge_stone(width):
    ns = clog2(width)
    nw = width

    array = np.zeros((ns, nw), dtype=int)

    for stage in range(ns):
        for k, v in ks_gen(nw, stage):
            array[stage, k] = v + 1

    return array


def sklansky(width):
    ns = clog2(width)
    nw = npow2(width)

    array = np.zeros((ns, nw), dtype=int)
    for s, stage in enumerate(
        range(1, ns + 1),
        start=0,
    ):
        for k, v in sk_gen(stage, nw):
            array[s, k] = v + 1

    return array[:, :width]


def brent_kung(width):
    ns = clog2(width)
    nw = npow2(width)

    array = np.zeros((2 * ns - 1, nw), dtype=int)

    for s, stage in enumerate(
        range(1, ns + 1),
        start=0,
    ):
        for k, v in bk_gen1(nw, stage):
            array[s, k] = v + 1
    for s, stage in enumerate(
        range(ns - 1, 0, -1),
        start=ns,
    ):
        for k, v in bk_gen2(nw, stage):
            array[s, k] = v + 1

    return array[:, :width]


def han_carlson_v1(width):
    ns = clog2(width)
    nw = npow2(width)

    array = np.zeros((ns + 1, nw), dtype=int)

    for stage in range(ns):
        for k, v in ks_gen(nw, stage, 2):
            array[stage, k] = v + 1
    for k, v in bk_gen2(nw, 1):
        array[ns, k] = v + 1

    return array[:, :width]


def han_carlson_v2(width):
    ns = clog2(width)
    nw = npow2(width)

    array = np.zeros((ns + 2, nw), dtype=int)

    for k, v in bk_gen1(nw, 1):
        array[0, k] = v + 1
    for k, v in bk_gen1(nw, 2):
        array[1, k] = v + 1
    for stage in range(2, ns + 1):
        for k, v in ks_gen(nw, stage, 4):
            array[stage, k] = v + 1
    for k, v in bk_gen2(nw, 2):
        array[ns, k] = v + 1
    for k, v in bk_gen2(nw, 1):
        array[ns + 1, k] = v + 1

    return array[:, :width]


def ladner_fischer(width):
    ns = clog2(width)
    nw = npow2(width)

    array = np.zeros((ns + 1, nw), dtype=int)

    for stage in range(ns):
        for k, v in sk_gen(nw, stage + 1, 2):
            array[stage, k] = v + 1
    for k, v in bk_gen2(nw, 1):
        array[ns, k] = v + 1

    return array[:, :width]


from mako.lookup import TemplateLookup
from mako.template import Template

TEMPLATE_FILENAME = "pg_tree.mako"

LOOKUP = TemplateLookup(directories=["."])


def gen(array, name="pg_tree", template_filename=TEMPLATE_FILENAME):
    template = Template(filename=template_filename, lookup=LOOKUP)
    code = template.render(array=array, name=name)
    return code


ARCHITECTURES = [
    ("sk", sklansky, "Sklansky"),
    ("bk", brent_kung, "Brent-Kung"),
    ("ks", kogge_stone, "Kogge-Stone"),
    ("h1", han_carlson_v1, "Han-Carlson"),
    ("h2", han_carlson_v2, "Han-Carlson 2"),
    ("lf", ladner_fischer, "Ladner-Fischer"),
]
