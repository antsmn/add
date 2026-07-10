
include nangate.mk

STA_DIR = ../sta

export SRC_DIR
export OUT_DIR
export STA_DIR
export NETLIST

YOSYS_FLAGS =

.SUFFIXES:
.SUFFIXES: .tcl

.tcl:
	@VLOG_TOP=$(VLOG_TOP) VLOG_FLIST=$(VLOG_FLIST) VLOG_DEFINES="$(VLOG_DEFINES)" VLOG_PARAMS="$(VLOG_PARAMS)" TMPDIR=. \
	yosys -m slang $(YOSYS_FLAGS) -QT $<

sta:
	@make VLOG_TOP=$(VLOG_TOP) VLOG_FILES=$(OUT_DIR)/$(NETLIST) TECH_LIB="$(TECH_LIB)" -C $(STA_DIR) $@
