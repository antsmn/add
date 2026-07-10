
set clk_period $::env(CLK_PERIOD)
set clk_frac 0.01

set clk_name $::env(CLK_NAME)
set clk_port $::env(CLK_PORT)

create_clock -name $clk_name -period $clk_period [get_ports -quiet $clk_port]

# set_clock_uncertainty $clk_frac clk

set no_clk_inputs [all_inputs -no_clocks]

set_input_delay  [expr $clk_period * $clk_frac] -clock clk $no_clk_inputs
set_output_delay [expr $clk_period * $clk_frac] -clock clk [all_outputs]

set_false_path -from [get_ports rstn]

# set_timing_derate -late 1.05
# set_timing_derate -early 0.95
