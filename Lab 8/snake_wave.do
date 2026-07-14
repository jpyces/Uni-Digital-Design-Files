onerror {resume}
quietly WaveActivateNextPane {} 0
add wave -noupdate /snake_tb/dut/MAX_LENGTH
add wave -noupdate /snake_tb/dut/endGame
add wave -noupdate /snake_tb/dut/eaten
add wave -noupdate /snake_tb/dut/game_rst
add wave -noupdate /snake_tb/dut/game_tick
add wave -noupdate /snake_tb/dut/clk
add wave -noupdate /snake_tb/dut/dir
add wave -noupdate /snake_tb/dut/snake_array
add wave -noupdate /snake_tb/dut/snake_len
add wave -noupdate /snake_tb/dut/board_edge
add wave -noupdate /snake_tb/dut/head_x
add wave -noupdate /snake_tb/dut/head_y
add wave -noupdate /snake_tb/dut/next_x_comb
add wave -noupdate /snake_tb/dut/next_y_comb
add wave -noupdate /snake_tb/dut/current_dir
TreeUpdate [SetDefaultTree]
WaveRestoreCursors {{Cursor 1} {7 ps} 0}
quietly wave cursor active 1
configure wave -namecolwidth 170
configure wave -valuecolwidth 100
configure wave -justifyvalue left
configure wave -signalnamewidth 0
configure wave -snapdistance 10
configure wave -datasetprefix 0
configure wave -rowmargin 4
configure wave -childrowmargin 2
configure wave -gridoffset 0
configure wave -gridperiod 100
configure wave -griddelta 40
configure wave -timeline 0
configure wave -timelineunits ps
update
WaveRestoreZoom {1400 ps} {1558 ps}
