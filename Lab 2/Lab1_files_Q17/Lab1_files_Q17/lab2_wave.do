onerror {resume}
quietly WaveActivateNextPane {} 0
add wave -noupdate {/lab2_tb/LEDR[0]}
add wave -noupdate /lab2_tb/dut/v1
add wave -noupdate /lab2_tb/dut/v2
add wave -noupdate /lab2_tb/dut/A
add wave -noupdate /lab2_tb/dut/B
add wave -noupdate /lab2_tb/dut/C
add wave -noupdate /lab2_tb/dut/D
add wave -noupdate /lab2_tb/dut/E
add wave -noupdate /lab2_tb/dut/F
add wave -noupdate /lab2_tb/dut/G
add wave -noupdate /lab2_tb/dut/H
TreeUpdate [SetDefaultTree]
WaveRestoreCursors {{Cursor 1} {90 ps} 0}
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
configure wave -gridperiod 1
configure wave -griddelta 40
configure wave -timeline 0
configure wave -timelineunits ps
update
WaveRestoreZoom {0 ps} {2688 ps}
