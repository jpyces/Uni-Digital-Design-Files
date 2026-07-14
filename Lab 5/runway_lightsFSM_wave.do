onerror {resume}
quietly WaveActivateNextPane {} 0
add wave -noupdate -label reset /runway_lightsFSM_tb/reset
add wave -noupdate -label clk /runway_lightsFSM_tb/clk
add wave -noupdate -label SW -expand /runway_lightsFSM_tb/SW
add wave -noupdate -label out -expand /runway_lightsFSM_tb/out
TreeUpdate [SetDefaultTree]
WaveRestoreCursors {{Cursor 1} {80 ps} 0}
quietly wave cursor active 1
configure wave -namecolwidth 150
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
WaveRestoreZoom {0 ps} {2048 ps}
