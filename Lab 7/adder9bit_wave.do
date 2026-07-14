onerror {resume}
quietly WaveActivateNextPane {} 0
add wave -noupdate -radix decimal /adder9bit_tb/a
add wave -noupdate -radix decimal /adder9bit_tb/b
add wave -noupdate -radix decimal /adder9bit_tb/sum
add wave -noupdate /adder9bit_tb/cout
TreeUpdate [SetDefaultTree]
WaveRestoreCursors {{Cursor 1} {0 ps} 0}
quietly wave cursor active 0
configure wave -namecolwidth 167
configure wave -valuecolwidth 122
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
WaveRestoreZoom {0 ps} {973 ps}
