onerror {resume}
quietly WaveActivateNextPane {} 0
add wave -noupdate /nes_controller_driver_tb/clk
add wave -noupdate /nes_controller_driver_tb/rst
add wave -noupdate /nes_controller_driver_tb/nes_enable
add wave -noupdate /nes_controller_driver_tb/nes_data_sync
add wave -noupdate /nes_controller_driver_tb/latch_out
add wave -noupdate /nes_controller_driver_tb/clk_out
add wave -noupdate /nes_controller_driver_tb/buttons
TreeUpdate [SetDefaultTree]
WaveRestoreCursors {{Cursor 1} {0 ps} 0}
quietly wave cursor active 0
configure wave -namecolwidth 297
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
WaveRestoreZoom {0 ps} {899 ps}
