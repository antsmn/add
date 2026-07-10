
export TECH_LIB_DIR =
export TECH_LIB     =
export TECH_LIB_FF  =
export TECH_LIB_SS  =

export CLK_NAME = clk
export CLK_PORT = clk
export CLK_PERIOD   = 1

.SUFFIXES:
.SUFFIXES: .tcl

.tcl:
	@VLOG_TOP=$(VLOG_TOP) VLOG_FILES=$(VLOG_FILES) sta -exit -no_splash $<
