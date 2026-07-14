onerror {resume}
quietly WaveActivateNextPane {} 0
add wave -noupdate /game_state_tb/MAX_SNAKE_LENGTH
add wave -noupdate -label R /game_state_tb/SEG_RST_D5
add wave -noupdate -label S /game_state_tb/SEG_RST_D4
add wave -noupdate -label T /game_state_tb/SEG_RST_D3
add wave -noupdate -label P /game_state_tb/SEG_RUN_D5
add wave -noupdate -label L /game_state_tb/SEG_RUN_D4
add wave -noupdate -label Y /game_state_tb/SEG_RUN_D3
add wave -noupdate -label EMPTY /game_state_tb/SEG_LOSE_D5
add wave -noupdate -label L /game_state_tb/SEG_LOSE_D4
add wave -noupdate -label EMPTY /game_state_tb/SEG_LOSE_D3
add wave -noupdate -label {w left} /game_state_tb/SEG_WIN_D5
add wave -noupdate -label {w middle} /game_state_tb/SEG_WIN_D4
add wave -noupdate -label {w right} /game_state_tb/SEG_WIN_D3
add wave -noupdate /game_state_tb/clk
add wave -noupdate /game_state_tb/rst
add wave -noupdate /game_state_tb/suicide
add wave -noupdate /game_state_tb/board_edge
add wave -noupdate /game_state_tb/game_tick
add wave -noupdate /game_state_tb/snake_len
add wave -noupdate /game_state_tb/display5
add wave -noupdate /game_state_tb/display4
add wave -noupdate /game_state_tb/display3
add wave -noupdate /game_state_tb/game_rst
add wave -noupdate /game_state_tb/endGame
add wave -noupdate /game_state_tb/win
TreeUpdate [SetDefaultTree]
WaveRestoreCursors {{Cursor 1} {0 ps} 0}
quietly wave cursor active 1
configure wave -namecolwidth 246
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
WaveRestoreZoom {0 ps} {164 ps}
