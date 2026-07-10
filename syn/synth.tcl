yosys -import

file mkdir $::env(OUT_DIR)

set slang_args "-D SYNTHESIS"

foreach arg $::env(VLOG_DEFINES) {
    lappend slang_args -D $arg
}
foreach arg $::env(VLOG_PARAMS) {
    lappend slang_args -G $arg
}

if {$::env(VLOG_FLIST) != ""} {
    read_slang {*}$slang_args -F $::env(VLOG_FLIST) --keep-hierarchy --top $::env(VLOG_TOP)
}
if {$::env(VLOG_FILES) != ""} {
    read_slang {*}$slang_args {*}[glob $::env(VLOG_FILES)] --keep-hierarchy --top $::env(VLOG_TOP)
}

set lib_args ""

foreach file $::env(TECH_LIB) {
    read_liberty -lib $file
}
foreach file $::env(TECH_LIB) {
    lappend lib_args -liberty $file
}

prep -run :check -flatten -top $::env(VLOG_TOP)

foreach file $::env(TECH_MAP_FILES) {
    techmap -map $file
}
techmap
opt

set abc_script "+strash; map; topo; upsize; dnsize "

set dont_use_args [list]
foreach cell $::env(DONT_USE_CELLS) {
    lappend dont_use_args -dont_use $cell
}

dfflibmap {*}$lib_args {*}$dont_use_args

abc {*}$lib_args {*}$dont_use_args -dff -script $abc_script

splitnets
clean -purge

hilomap -singleton -hicell {*}$::env(TIEHI_CELL_AND_PORT)
hilomap -singleton -locell {*}$::env(TIELO_CELL_AND_PORT)

check -assert

write_verilog -simple-lhs -nohex -nodec -noattr -noexpr $::env(OUT_DIR)/$::env(NETLIST)

stat {*}$lib_args
