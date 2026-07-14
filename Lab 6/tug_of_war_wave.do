onerror {resume}
quietly WaveActivateNextPane {} 0
add wave -noupdate /tug_of_war_tb/clk
add wave -noupdate {/tug_of_war_tb/KEY[3]}
add wave -noupdate {/tug_of_war_tb/KEY[0]}
add wave -noupdate {/tug_of_war_tb/SW[9]}
add wave -noupdate /tug_of_war_tb/HEX0
add wave -noupdate -expand /tug_of_war_tb/LEDR
TreeUpdate [SetDefaultTree]
WaveRestoreCursors {{Cursor 1} {0 ps} 0}
quietly wave cursor active 1
configure wave -namecolwidth 305
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
WaveRestoreZoom {0 ps} {2510 ps}
