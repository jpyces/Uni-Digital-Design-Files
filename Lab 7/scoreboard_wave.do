onerror {resume}
quietly WaveActivateNextPane {} 0
add wave -noupdate /scoreboard_tb/clk
add wave -noupdate /scoreboard_tb/rst
add wave -noupdate /scoreboard_tb/p1win
add wave -noupdate /scoreboard_tb/p2win
add wave -noupdate /scoreboard_tb/display0
add wave -noupdate /scoreboard_tb/display1
add wave -noupdate /scoreboard_tb/playfield_rst
TreeUpdate [SetDefaultTree]
WaveRestoreCursors {{Cursor 1} {0 ps} 0}
quietly wave cursor active 0
configure wave -namecolwidth 213
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
WaveRestoreZoom {0 ps} {957 ps}
