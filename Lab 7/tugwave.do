onerror {resume}
quietly WaveActivateNextPane {} 0
add wave -noupdate /tug_of_war_tb/rst
add wave -noupdate /tug_of_war_tb/clk
add wave -noupdate {/tug_of_war_tb/inputs[3]}
add wave -noupdate {/tug_of_war_tb/inputs[0]}
add wave -noupdate /tug_of_war_tb/display
add wave -noupdate -expand /tug_of_war_tb/leds
add wave -noupdate {/tug_of_war_tb/switches[9]}
TreeUpdate [SetDefaultTree]
WaveRestoreCursors {{Cursor 1} {0 ps} 0}
quietly wave cursor active 1
configure wave -namecolwidth 230
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
WaveRestoreZoom {0 ps} {4883 ps}
