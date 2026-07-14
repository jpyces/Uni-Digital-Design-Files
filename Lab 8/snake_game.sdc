# Clock
create_clock -period 20.0 -name CLOCK_50 [get_ports CLOCK_50]

# Input delays
set_input_delay -clock CLOCK_50 -max 3.0 [all_inputs]
set_input_delay -clock CLOCK_50 -min 0.0 [all_inputs]

# Output delays
set_output_delay -clock CLOCK_50 -max 3.0 [all_outputs]
set_output_delay -clock CLOCK_50 -min 0.0 [all_outputs]

# False paths for async inputs
#set_false_path -from [get_ports {KEY[0]}]
#set_false_path -from [get_ports {KEY[1]}]
#set_false_path -from [get_ports {KEY[2]}]
#set_false_path -from [get_ports {KEY[3]}]
#set_false_path -from [get_ports {SW[9]}]

# False path for GPIO output
set_false_path -to [get_ports {GPIO_1[*]}]

