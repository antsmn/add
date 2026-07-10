
export TECH_LIB_DIR = /Users/antoniosimone/h/nangate45
export TECH_LIB     = $(TECH_LIB_DIR)/nangate45_typ.lib.gz
export TECH_LIB_FF  =
export TECH_LIB_SS  =

# adder map file miss constant folding for propagate inputs and constant 1'b1, just ignore
export TECH_MAP_FILES =
export DONT_USE_CELLS =

export MIN_BUF_CELL_AND_PORTS = BUF_X1 A Z
export TIEHI_CELL_AND_PORT    = LOGIC1_X1 Z
export TIELO_CELL_AND_PORT    = LOGIC0_X1 Z
