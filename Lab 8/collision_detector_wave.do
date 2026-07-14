onerror {resume}
quietly WaveActivateNextPane {} 0
add wave -noupdate /collision_detector_tb/endGame
add wave -noupdate -radix unsigned /collision_detector_tb/apple_x
add wave -noupdate -radix unsigned /collision_detector_tb/apple_y
add wave -noupdate /collision_detector_tb/eaten
add wave -noupdate /collision_detector_tb/suicide
add wave -noupdate -radix unsigned /collision_detector_tb/snake_len
add wave -noupdate /collision_detector_tb/snake_array
TreeUpdate [SetDefaultTree]
WaveRestoreCursors {{Cursor 1} {5 ps} 0}
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
WaveRestoreZoom {0 ps} {14 ps}
