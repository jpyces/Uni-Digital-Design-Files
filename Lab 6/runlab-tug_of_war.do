# Create work library
vlib work

# Compile Verilog
#     All Verilog files that are part of this design should have
#     their own "vlog" line below.
vlog "./tug_of_war.sv"
vlog "./normal_light.sv"
vlog "./pulse.sv"
vlog "./synch.sv"
vlog "./user_input.sv"
vlog "./victory.sv"
vlog "./normal_light_leftmost.sv"
vlog "./normal_light_rightmost.sv"
vlog "./center_light.sv"
vlog "./clock_divider.sv"

# Call vsim to invoke simulator
#     Make sure the last item on the line is the name of the
#     testbench module you want to execute.
vsim -voptargs="+acc" -t 1ps -lib work tug_of_war_tb

# Source the wave do file
#     This should be the file that sets up the signal window for
#     the module you are testing.
do tug_of_war_wave.do

# Set the window types
view wave
view structure
view signals

# Run the simulation
run -all

# End
