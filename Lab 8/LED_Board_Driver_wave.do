onerror {resume}
quietly virtual function -install /LED_Board_Driver_tb -env /LED_Board_Driver_tb/#INITIAL#38(#ublk#148407346#38) { &{/LED_Board_Driver_tb/snake_array[0][7], /LED_Board_Driver_tb/snake_array[0][6], /LED_Board_Driver_tb/snake_array[0][5], /LED_Board_Driver_tb/snake_array[0][4] }} SNAKE_HEAD_X
quietly virtual function -install /LED_Board_Driver_tb -env /LED_Board_Driver_tb/#INITIAL#38(#ublk#148407346#38) { &{/LED_Board_Driver_tb/snake_array[0][3], /LED_Board_Driver_tb/snake_array[0][2], /LED_Board_Driver_tb/snake_array[0][1], /LED_Board_Driver_tb/snake_array[0][0] }} snake_head_y
quietly virtual function -install /LED_Board_Driver_tb -env /LED_Board_Driver_tb/#INITIAL#38(#ublk#148407346#38) { &{/LED_Board_Driver_tb/snake_array[1][7], /LED_Board_Driver_tb/snake_array[1][6], /LED_Board_Driver_tb/snake_array[1][5], /LED_Board_Driver_tb/snake_array[1][4] }} TAIL_1_X
quietly virtual function -install /LED_Board_Driver_tb -env /LED_Board_Driver_tb/#INITIAL#38(#ublk#148407346#38) { &{/LED_Board_Driver_tb/snake_array[1][3], /LED_Board_Driver_tb/snake_array[1][2], /LED_Board_Driver_tb/snake_array[1][1], /LED_Board_Driver_tb/snake_array[1][0] }} TAIL_1_Y
quietly virtual function -install /LED_Board_Driver_tb -env /LED_Board_Driver_tb/#INITIAL#38(#ublk#148407346#38) { &{/LED_Board_Driver_tb/snake_array[2][7], /LED_Board_Driver_tb/snake_array[2][6], /LED_Board_Driver_tb/snake_array[2][5], /LED_Board_Driver_tb/snake_array[2][4] }} TAIL_2_X
quietly virtual function -install /LED_Board_Driver_tb -env /LED_Board_Driver_tb/#INITIAL#38(#ublk#148407346#38) { &{/LED_Board_Driver_tb/snake_array[2][3], /LED_Board_Driver_tb/snake_array[2][2], /LED_Board_Driver_tb/snake_array[2][1], /LED_Board_Driver_tb/snake_array[2][0] }} TAIL_2_Y
quietly WaveActivateNextPane {} 0
add wave -noupdate /LED_Board_Driver_tb/MAX_LENGTH
add wave -noupdate -radix unsigned /LED_Board_Driver_tb/apple_x
add wave -noupdate -radix unsigned /LED_Board_Driver_tb/apple_y
add wave -noupdate -radix unsigned -childformat {{{/LED_Board_Driver_tb/snake_len[7]} -radix unsigned} {{/LED_Board_Driver_tb/snake_len[6]} -radix unsigned} {{/LED_Board_Driver_tb/snake_len[5]} -radix unsigned} {{/LED_Board_Driver_tb/snake_len[4]} -radix unsigned} {{/LED_Board_Driver_tb/snake_len[3]} -radix unsigned} {{/LED_Board_Driver_tb/snake_len[2]} -radix unsigned} {{/LED_Board_Driver_tb/snake_len[1]} -radix unsigned} {{/LED_Board_Driver_tb/snake_len[0]} -radix unsigned}} -subitemconfig {{/LED_Board_Driver_tb/snake_len[7]} {-radix unsigned} {/LED_Board_Driver_tb/snake_len[6]} {-radix unsigned} {/LED_Board_Driver_tb/snake_len[5]} {-radix unsigned} {/LED_Board_Driver_tb/snake_len[4]} {-radix unsigned} {/LED_Board_Driver_tb/snake_len[3]} {-radix unsigned} {/LED_Board_Driver_tb/snake_len[2]} {-radix unsigned} {/LED_Board_Driver_tb/snake_len[1]} {-radix unsigned} {/LED_Board_Driver_tb/snake_len[0]} {-radix unsigned}} /LED_Board_Driver_tb/snake_len
add wave -noupdate -radix unsigned -childformat {{(3) -radix unsigned} {(2) -radix unsigned} {(1) -radix unsigned} {(0) -radix unsigned}} -subitemconfig {{/LED_Board_Driver_tb/snake_array[0][7]} {-radix unsigned} {/LED_Board_Driver_tb/snake_array[0][6]} {-radix unsigned} {/LED_Board_Driver_tb/snake_array[0][5]} {-radix unsigned} {/LED_Board_Driver_tb/snake_array[0][4]} {-radix unsigned}} /LED_Board_Driver_tb/SNAKE_HEAD_X
add wave -noupdate -radix unsigned /LED_Board_Driver_tb/snake_head_y
add wave -noupdate -radix unsigned /LED_Board_Driver_tb/TAIL_1_X
add wave -noupdate -radix unsigned /LED_Board_Driver_tb/TAIL_1_Y
add wave -noupdate -radix unsigned /LED_Board_Driver_tb/TAIL_2_X
add wave -noupdate -radix unsigned /LED_Board_Driver_tb/TAIL_2_Y
add wave -noupdate /LED_Board_Driver_tb/RedPixels
add wave -noupdate /LED_Board_Driver_tb/GreenPixels
add wave -noupdate /LED_Board_Driver_tb/game_rst
TreeUpdate [SetDefaultTree]
WaveRestoreCursors {{Cursor 1} {4 ps} 0}
quietly wave cursor active 1
configure wave -namecolwidth 286
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
WaveRestoreZoom {0 ps} {8 ps}
