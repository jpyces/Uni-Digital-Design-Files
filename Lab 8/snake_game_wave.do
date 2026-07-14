onerror {resume}
quietly virtual function -install /snake_game_tb/dut -env /snake_game_tb { &{/snake_game_tb/dut/snake_array[1][7], /snake_game_tb/dut/snake_array[1][6], /snake_game_tb/dut/snake_array[1][5], /snake_game_tb/dut/snake_array[1][4] }} TAIL_1_X
quietly virtual function -install /snake_game_tb/dut -env /snake_game_tb { &{/snake_game_tb/dut/snake_array[1][3], /snake_game_tb/dut/snake_array[1][2], /snake_game_tb/dut/snake_array[1][1], /snake_game_tb/dut/snake_array[1][0] }} TAIL_1_Y
quietly virtual function -install /snake_game_tb/dut -env /snake_game_tb { &{/snake_game_tb/dut/snake_array[2][7], /snake_game_tb/dut/snake_array[2][6], /snake_game_tb/dut/snake_array[2][5], /snake_game_tb/dut/snake_array[2][4] }} TAIL_2_X
quietly virtual function -install /snake_game_tb/dut -env /snake_game_tb { &{/snake_game_tb/dut/snake_array[2][3], /snake_game_tb/dut/snake_array[2][2], /snake_game_tb/dut/snake_array[2][1], /snake_game_tb/dut/snake_array[2][0] }} TAIL_2_Y
quietly virtual function -install /snake_game_tb -env /snake_game_tb { &{/snake_game_tb/SW[8], /snake_game_tb/SW[7], /snake_game_tb/SW[6], /snake_game_tb/SW[5], /snake_game_tb/SW[4], /snake_game_tb/SW[3], /snake_game_tb/SW[2], /snake_game_tb/SW[1], /snake_game_tb/SW[0] }} TICK_SPEED
quietly virtual function -install /snake_game_tb/dut -env /snake_game_tb/dut { &{/snake_game_tb/dut/snake_array[0][7], /snake_game_tb/dut/snake_array[0][6], /snake_game_tb/dut/snake_array[0][5], /snake_game_tb/dut/snake_array[0][4] }} Snake_HEAD_x
quietly virtual function -install /snake_game_tb/dut -env /snake_game_tb/dut { &{/snake_game_tb/dut/snake_array[0][3], /snake_game_tb/dut/snake_array[0][2], /snake_game_tb/dut/snake_array[0][1], /snake_game_tb/dut/snake_array[0][0] }} Snake_HEAD_Y
quietly WaveActivateNextPane {} 0
add wave -noupdate /snake_game_tb/dut/MAX_LENGTH
add wave -noupdate /snake_game_tb/TB_CLK_FREQ
add wave -noupdate /snake_game_tb/TB_TICKS_SEC
add wave -noupdate /snake_game_tb/CYCLES_PER_TICK
add wave -noupdate /snake_game_tb/CLOCK_PERIOD
add wave -noupdate /snake_game_tb/CLOCK_50
add wave -noupdate -label {TEST #} -radix unsigned -childformat {{{/snake_game_tb/test_id[7]} -radix unsigned} {{/snake_game_tb/test_id[6]} -radix unsigned} {{/snake_game_tb/test_id[5]} -radix unsigned} {{/snake_game_tb/test_id[4]} -radix unsigned} {{/snake_game_tb/test_id[3]} -radix unsigned} {{/snake_game_tb/test_id[2]} -radix unsigned} {{/snake_game_tb/test_id[1]} -radix unsigned} {{/snake_game_tb/test_id[0]} -radix unsigned}} -subitemconfig {{/snake_game_tb/test_id[7]} {-height 15 -radix unsigned} {/snake_game_tb/test_id[6]} {-height 15 -radix unsigned} {/snake_game_tb/test_id[5]} {-height 15 -radix unsigned} {/snake_game_tb/test_id[4]} {-height 15 -radix unsigned} {/snake_game_tb/test_id[3]} {-height 15 -radix unsigned} {/snake_game_tb/test_id[2]} {-height 15 -radix unsigned} {/snake_game_tb/test_id[1]} {-height 15 -radix unsigned} {/snake_game_tb/test_id[0]} {-height 15 -radix unsigned}} /snake_game_tb/test_id
add wave -noupdate -label {SW[9]_RESET} {/snake_game_tb/SW[9]}
add wave -noupdate -radix unsigned /snake_game_tb/TICK_SPEED
add wave -noupdate /snake_game_tb/dut/game_tick
add wave -noupdate /snake_game_tb/dut/game_rst
add wave -noupdate -label Snake_HEAD_X -radix unsigned /snake_game_tb/dut/Snake_HEAD_x
add wave -noupdate -label Snake_HEAD_Y -radix unsigned /snake_game_tb/dut/Snake_HEAD_Y
add wave -noupdate -radix unsigned /snake_game_tb/dut/TAIL_1_X
add wave -noupdate -radix unsigned /snake_game_tb/dut/TAIL_1_Y
add wave -noupdate -radix unsigned /snake_game_tb/dut/TAIL_2_X
add wave -noupdate -radix unsigned /snake_game_tb/dut/TAIL_2_Y
add wave -noupdate -label {snake len} -radix unsigned /snake_game_tb/dut/snake_len
add wave -noupdate -label APPLE_X -radix unsigned /snake_game_tb/dut/apple_x
add wave -noupdate -label APPLE_Y -radix unsigned /snake_game_tb/dut/apple_y
add wave -noupdate /snake_game_tb/dut/eaten
add wave -noupdate /snake_game_tb/dut/eaten_latch
add wave -noupdate /snake_game_tb/dut/suicide
add wave -noupdate /snake_game_tb/dut/board_edge
add wave -noupdate /snake_game_tb/dut/endGame
add wave -noupdate /snake_game_tb/dut/nes_data
add wave -noupdate -label {NES DATA Post-CDC} /snake_game_tb/dut/nes_data_ff1
add wave -noupdate /snake_game_tb/dut/nes_buttons
add wave -noupdate /snake_game_tb/dut/nes_latch_out
add wave -noupdate /snake_game_tb/dut/nes_clock_out
add wave -noupdate /snake_game_tb/dut/nes_enable
add wave -noupdate /snake_game_tb/dut/ui/dir
add wave -noupdate /snake_game_tb/dut/sn/current_dir
add wave -noupdate /snake_game_tb/dut/RedPixels_comb
add wave -noupdate /snake_game_tb/dut/GreenPixels_comb
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
