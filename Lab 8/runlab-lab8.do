# Create work library
vlib work

# Compile Verilog
#     All Verilog files that are part of this design should have
#     their own "vlog" line below.
vlog "./LEDDriver.sv"
vlog "./lab8.sv"
vlog "./game_state.sv"
vlog "./snake.sv"
vlog "./apple.sv"
vlog "./LED_Board_Driver.sv"
vlog "./game_tick_gen.sv"
vlog "./synch.sv"
vlog "./lfsr8bit.sv"
vlog "./user_input.sv"
vlog "./nes_controller_driver.sv"
vlog "./score_display.sv"
vlog "./hex_decoder.sv"


# Call vsim to invoke simulator
#     Make sure the last item on the line is the name of the
#     testbench module you want to execute.
vsim -voptargs="+acc" -t 1ps -lib work lab8_tb

# Source the wave do file
#     This should be the file that sets up the signal window for
#     the module you are testing.
do lab8_wave.do

# Set the window types
view wave
view structure
view signals

# Run the simulation
run -all

# End
