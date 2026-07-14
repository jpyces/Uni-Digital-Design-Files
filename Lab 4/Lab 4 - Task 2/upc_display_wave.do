onerror {resume}
quietly WaveActivateNextPane {} 0
add wave -noupdate /upc_display_tb/U
add wave -noupdate /upc_display_tb/P
add wave -noupdate /upc_display_tb/C
add wave -noupdate /upc_display_tb/m0
add wave -noupdate /upc_display_tb/m1
add wave -noupdate /upc_display_tb/m2
add wave -noupdate /upc_display_tb/m3
add wave -noupdate /upc_display_tb/m4
add wave -noupdate /upc_display_tb/m5
TreeUpdate [SetDefaultTree]
WaveRestoreCursors {{Cursor 1} {0 ps} 0}
quietly wave cursor active 0
configure wave -namecolwidth 150
configure wave -valuecolwidth 100
configure wave -justifyvalue left
configure wave -signalnamewidth 0
configure wave -snapdistance 10
configure wave -datasetprefix 0
configure wave -rowmargin 4
configure wave -childrowmargin 2
configure wave -gridoffset 0
configure wave -gridperiod 1
configure wave -griddelta 40
configure wave -timeline 0
configure wave -timelineunits ps
update
WaveRestoreZoom {0 ps} {1 ns}
