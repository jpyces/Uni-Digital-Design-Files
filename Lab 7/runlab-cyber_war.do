# Create work library
vlib work

# Compile Verilog
#     All Verilog files that are part of this design should have
#     their own "vlog" line below.
vlog "./cyber_war.sv"
vlog "./normal_light.sv"
vlog "./pulse.sv"
vlog "./synch.sv"
vlog "./user_input.sv"
vlog "./normal_light_leftmost.sv"
vlog "./normal_light_rightmost.sv"
vlog "./center_light.sv"
vlog "./clock_divider.sv"
vlog "./presser.sv"
vlog "./lfsr9bit.sv"
vlog "./full_adder.sv"
vlog "./adder9bit.sv"
vlog "./scoreboard.sv"
vlog "./seg7_decoder.sv"
vlog "./counter3bit.sv"

# Call vsim to invoke simulator
#     Make sure the last item on the line is the name of the
#     testbench module you want to execute.
vsim -voptargs="+acc" -t 1ps -lib work cyber_war_tb

# Source the wave do file
#     This should be the file that sets up the signal window for
#     the module you are testing.
do cyber_war_wave.do

# Set the window types
view wave
view structure
view signals

# Run the simulation
run -all

# End
