onerror {resume}
quietly WaveActivateNextPane {} 0
add wave -noupdate /apple_tb/endGame
add wave -noupdate /apple_tb/game_rst
add wave -noupdate /apple_tb/eaten
add wave -noupdate /apple_tb/clk
add wave -noupdate /apple_tb/snake_array
add wave -noupdate /apple_tb/snake_len
add wave -noupdate /apple_tb/apple_x
add wave -noupdate /apple_tb/apple_y
add wave -noupdate /apple_tb/dut/has_collision
add wave -noupdate /apple_tb/dut/cand_apple_coords
add wave -noupdate /apple_tb/dut/lfsr_out
add wave -noupdate /apple_tb/dut/ps
add wave -noupdate /apple_tb/dut/ns
TreeUpdate [SetDefaultTree]
WaveRestoreCursors {{Cursor 1} {0 ps} 0}
quietly wave cursor active 1
configure wave -namecolwidth 245
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
WaveRestoreZoom {0 ps} {4253 ps}
