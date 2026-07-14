onerror {resume}
quietly WaveActivateNextPane {} 0
add wave -noupdate /normal_light_leftmost_tb/clk
add wave -noupdate /normal_light_leftmost_tb/rst
add wave -noupdate /normal_light_leftmost_tb/L
add wave -noupdate /normal_light_leftmost_tb/R
add wave -noupdate /normal_light_leftmost_tb/NR
add wave -noupdate /normal_light_leftmost_tb/lightOn
add wave -noupdate /normal_light_leftmost_tb/endGame
TreeUpdate [SetDefaultTree]
WaveRestoreCursors {{Cursor 1} {2212 ps} 0}
quietly wave cursor active 1
configure wave -namecolwidth 211
configure wave -valuecolwidth 66
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
WaveRestoreZoom {0 ps} {3833 ps}
