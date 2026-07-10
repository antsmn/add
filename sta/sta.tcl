
suppress_msg 1212

foreach file $::env(TECH_LIB) {
    read_liberty $file
}
read_verilog $::env(VLOG_FILES)
link_design  $::env(VLOG_TOP)

set_cmd_units -time ns -capacitance fF -current uA -voltage V -resistance kOhm -distance um
set sta_report_default_digits 3

read_sdc sta.sdc

write_sdf $::env(OUT_DIR)/$::env(VLOG_TOP).sdf

report_checks -path_delay max -fields {cap fanout}


set_power_activity -input -activity 0.1
set_power_activity -input_port rstn -activity 0

report_power
