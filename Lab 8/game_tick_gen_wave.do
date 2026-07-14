onerror {resume}
quietly WaveActivateNextPane {} 0
add wave -noupdate /game_tick_gen_tb/CLK_FREQ
add wave -noupdate /game_tick_gen_tb/clk
add wave -noupdate /game_tick_gen_tb/rst
add wave -noupdate /game_tick_gen_tb/switches
add wave -noupdate /game_tick_gen_tb/game_tick
add wave -noupdate /game_tick_gen_tb/cycle_count
add wave -noupdate /game_tick_gen_tb/t_start
add wave -noupdate /game_tick_gen_tb/t_end
add wave -noupdate /game_tick_gen_tb/period
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
configure wave -gridperiod 100
configure wave -griddelta 40
configure wave -timeline 0
configure wave -timelineunits ps
update
WaveRestoreZoom {0 ps} {1 ns}
