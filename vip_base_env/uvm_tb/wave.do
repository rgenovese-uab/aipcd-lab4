onerror {resume}
quietly WaveActivateNextPane {} 0
add wave -noupdate -expand -group DCT /hdl_top/axi_slave/u_dct_compute/IDLE
add wave -noupdate -expand -group DCT /hdl_top/axi_slave/u_dct_compute/CONVERT
add wave -noupdate -expand -group DCT /hdl_top/axi_slave/u_dct_compute/DCT_ROW
add wave -noupdate -expand -group DCT /hdl_top/axi_slave/u_dct_compute/DCT_COL
add wave -noupdate -expand -group DCT /hdl_top/axi_slave/u_dct_compute/CONVERT_BACK
add wave -noupdate -expand -group DCT /hdl_top/axi_slave/u_dct_compute/DONE_ST
add wave -noupdate -expand -group DCT /hdl_top/axi_slave/u_dct_compute/clk
add wave -noupdate -expand -group DCT /hdl_top/axi_slave/u_dct_compute/reset_n
add wave -noupdate -expand -group DCT /hdl_top/axi_slave/u_dct_compute/start
add wave -noupdate -expand -group DCT /hdl_top/axi_slave/u_dct_compute/in_block
add wave -noupdate -expand -group DCT /hdl_top/axi_slave/u_dct_compute/out_block
add wave -noupdate -expand -group DCT /hdl_top/axi_slave/u_dct_compute/done
add wave -noupdate -expand -group DCT /hdl_top/axi_slave/u_dct_compute/i
add wave -noupdate -expand -group DCT /hdl_top/axi_slave/u_dct_compute/j
add wave -noupdate -expand -group DCT /hdl_top/axi_slave/u_dct_compute/u
add wave -noupdate -expand -group DCT /hdl_top/axi_slave/u_dct_compute/v
add wave -noupdate -expand -group DCT /hdl_top/axi_slave/u_dct_compute/compute_idx
add wave -noupdate -expand -group DCT /hdl_top/axi_slave/u_dct_compute/state
add wave -noupdate -expand -group DCT /hdl_top/axi_slave/u_dct_compute/temp
add wave -noupdate -expand -group DCT /hdl_top/axi_slave/u_dct_compute/alpha_u
add wave -noupdate -expand -group DCT /hdl_top/axi_slave/u_dct_compute/alpha_v
add wave -noupdate -expand -group DCT /hdl_top/axi_slave/u_dct_compute/sum
add wave -noupdate -expand -group DCT /hdl_top/axi_slave/u_dct_compute/cu
add wave -noupdate -expand -group DCT /hdl_top/axi_slave/u_dct_compute/cv
add wave -noupdate -expand -group DCT /hdl_top/axi_slave/u_dct_compute/input_real
add wave -noupdate -expand -group DCT /hdl_top/axi_slave/u_dct_compute/output_real
add wave -noupdate -expand -group DCT /hdl_top/axi_slave/u_dct_compute/temp_real
add wave -noupdate -expand -group DCT /hdl_top/axi_slave/u_dct_compute/cos_table
add wave -noupdate -expand -group AXI /hdl_top/axi_slave/DATA_WIDTH
add wave -noupdate -expand -group AXI /hdl_top/axi_slave/ADDR_WIDTH
add wave -noupdate -expand -group AXI /hdl_top/axi_slave/MEM_SIZE
add wave -noupdate -expand -group AXI /hdl_top/axi_slave/CTRL_ADDR_WORD
add wave -noupdate -expand -group AXI /hdl_top/axi_slave/STATUS_ADDR_WORD
add wave -noupdate -expand -group AXI /hdl_top/axi_slave/IN_BLOCK_START
add wave -noupdate -expand -group AXI /hdl_top/axi_slave/OUT_BLOCK_START
add wave -noupdate -expand -group AXI {/hdl_top/axi_slave/mem[2]}
add wave -noupdate -expand -group AXI /hdl_top/axi_slave/mem
add wave -noupdate -expand -group AXI /hdl_top/axi_slave/dct_start
add wave -noupdate -expand -group AXI /hdl_top/axi_slave/dct_done
add wave -noupdate -expand -group AXI /hdl_top/axi_slave/in_block
add wave -noupdate -expand -group AXI /hdl_top/axi_slave/out_block
add wave -noupdate -expand -group AXI -radix unsigned /hdl_top/axi_slave/write_count
add wave -noupdate -expand -group AXI /hdl_top/axi_slave/start_written
add wave -noupdate -expand -group AXI /hdl_top/axi_slave/dct_busy
add wave -noupdate -expand -group AXI /hdl_top/axi_slave/clk
add wave -noupdate -expand -group AXI /hdl_top/axi_slave/reset_n
add wave -noupdate -expand -group AXI /hdl_top/axi_slave/awid
add wave -noupdate -expand -group AXI /hdl_top/axi_slave/awaddr
add wave -noupdate -expand -group AXI /hdl_top/axi_slave/awlen
add wave -noupdate -expand -group AXI /hdl_top/axi_slave/awsize
add wave -noupdate -expand -group AXI /hdl_top/axi_slave/awburst
add wave -noupdate -expand -group AXI /hdl_top/axi_slave/awvalid
add wave -noupdate -expand -group AXI /hdl_top/axi_slave/awready
add wave -noupdate -expand -group AXI /hdl_top/axi_slave/wdata
add wave -noupdate -expand -group AXI /hdl_top/axi_slave/wstrb
add wave -noupdate -expand -group AXI /hdl_top/axi_slave/wlast
add wave -noupdate -expand -group AXI /hdl_top/axi_slave/wvalid
add wave -noupdate -expand -group AXI /hdl_top/axi_slave/wready
add wave -noupdate -expand -group AXI /hdl_top/axi_slave/bid
add wave -noupdate -expand -group AXI /hdl_top/axi_slave/bresp
add wave -noupdate -expand -group AXI /hdl_top/axi_slave/bvalid
add wave -noupdate -expand -group AXI /hdl_top/axi_slave/bready
add wave -noupdate -expand -group AXI /hdl_top/axi_slave/arid
add wave -noupdate -expand -group AXI /hdl_top/axi_slave/araddr
add wave -noupdate -expand -group AXI /hdl_top/axi_slave/arlen
add wave -noupdate -expand -group AXI /hdl_top/axi_slave/arsize
add wave -noupdate -expand -group AXI /hdl_top/axi_slave/arburst
add wave -noupdate -expand -group AXI /hdl_top/axi_slave/arvalid
add wave -noupdate -expand -group AXI /hdl_top/axi_slave/arready
add wave -noupdate -expand -group AXI /hdl_top/axi_slave/rid
add wave -noupdate -expand -group AXI /hdl_top/axi_slave/rdata
add wave -noupdate -expand -group AXI /hdl_top/axi_slave/rresp
add wave -noupdate -expand -group AXI /hdl_top/axi_slave/rlast
add wave -noupdate -expand -group AXI /hdl_top/axi_slave/rvalid
add wave -noupdate -expand -group AXI /hdl_top/axi_slave/rready
add wave -noupdate -expand -group AXI /hdl_top/axi_slave/dct_computing
add wave -noupdate -expand -group AXI /hdl_top/axi_slave/awid_reg
add wave -noupdate -expand -group AXI /hdl_top/axi_slave/awaddr_reg
add wave -noupdate -expand -group AXI /hdl_top/axi_slave/awlen_reg
add wave -noupdate -expand -group AXI /hdl_top/axi_slave/awsize_reg
add wave -noupdate -expand -group AXI /hdl_top/axi_slave/awburst_reg
add wave -noupdate -expand -group AXI /hdl_top/axi_slave/awburst_cnt
add wave -noupdate -expand -group AXI /hdl_top/axi_slave/aw_active
add wave -noupdate -expand -group AXI /hdl_top/axi_slave/arid_reg
add wave -noupdate -expand -group AXI /hdl_top/axi_slave/araddr_reg
add wave -noupdate -expand -group AXI /hdl_top/axi_slave/arlen_reg
add wave -noupdate -expand -group AXI /hdl_top/axi_slave/arsize_reg
add wave -noupdate -expand -group AXI /hdl_top/axi_slave/arburst_reg
add wave -noupdate -expand -group AXI /hdl_top/axi_slave/arburst_cnt
add wave -noupdate -expand -group AXI /hdl_top/axi_slave/ar_active
TreeUpdate [SetDefaultTree]
WaveRestoreCursors {{Cursor 1} {9 ns} 0}
quietly wave cursor active 1
configure wave -namecolwidth 687
configure wave -valuecolwidth 100
configure wave -justifyvalue left
configure wave -signalnamewidth 1
configure wave -snapdistance 10
configure wave -datasetprefix 0
configure wave -rowmargin 4
configure wave -childrowmargin 2
configure wave -gridoffset 0
configure wave -gridperiod 1
configure wave -griddelta 40
configure wave -timeline 0
configure wave -timelineunits ns
update
WaveRestoreZoom {2 ns} {28 ns}
