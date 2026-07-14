onerror {resume}
quietly WaveActivateNextPane {} 0
add wave -noupdate /lab8_tb/TB_CLK_FREQ
add wave -noupdate /lab8_tb/TB_TICKS_SEC
add wave -noupdate /lab8_tb/CYCLES_PER_TICK
add wave -noupdate /lab8_tb/CLOCK_PERIOD
add wave -noupdate /lab8_tb/PIPELINE_LATENCY
add wave -noupdate /lab8_tb/CLOCK_50
add wave -noupdate /lab8_tb/SW
add wave -noupdate /lab8_tb/nes_latch_out
add wave -noupdate /lab8_tb/nes_clock_out
add wave -noupdate /lab8_tb/nes_data
add wave -noupdate /lab8_tb/HEX0
add wave -noupdate /lab8_tb/HEX1
add wave -noupdate /lab8_tb/HEX2
add wave -noupdate /lab8_tb/HEX3
add wave -noupdate /lab8_tb/HEX4
add wave -noupdate /lab8_tb/HEX5
add wave -noupdate /lab8_tb/head_x0
add wave -noupdate /lab8_tb/head_y0
add wave -noupdate /lab8_tb/steps_left
add wave -noupdate /lab8_tb/hit
add wave -noupdate /lab8_tb/grew
add wave -noupdate /lab8_tb/edge_count
add wave -noupdate /lab8_tb/t_start
add wave -noupdate /lab8_tb/t_end
add wave -noupdate /lab8_tb/measured
add wave -noupdate /lab8_tb/test_id
TreeUpdate [SetDefaultTree]
WaveRestoreCursors {{Cursor 1} {4026 ps} 0} {{Cursor 2} {0 ps} 0}
quietly wave cursor active 1
configure wave -namecolwidth 310
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
WaveRestoreZoom {3605 ps} {8759 ps}
