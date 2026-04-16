onerror {resume}
quietly WaveActivateNextPane {} 0
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
add wave -noupdate -expand -group AXI /hdl_top/axi_slave/dct_start
add wave -noupdate -expand -group AXI /hdl_top/axi_slave/dct_done
add wave -noupdate -expand -group AXI /hdl_top/axi_slave/dct_busy
add wave -noupdate -expand -group AXI /hdl_top/axi_slave/awaddr_reg
add wave -noupdate -expand -group AXI /hdl_top/axi_slave/awburst_cnt
add wave -noupdate -expand -group AXI /hdl_top/axi_slave/aw_active
add wave -noupdate -expand -group AXI /hdl_top/axi_slave/awid_reg
add wave -noupdate -expand -group AXI /hdl_top/axi_slave/araddr_reg
add wave -noupdate -expand -group AXI /hdl_top/axi_slave/arburst_cnt
add wave -noupdate -expand -group AXI /hdl_top/axi_slave/ar_active
add wave -noupdate -expand -group AXI /hdl_top/axi_slave/arid_reg
add wave -noupdate -expand -group DCT /hdl_top/axi_slave/u_dct_compute/clk
add wave -noupdate -expand -group DCT /hdl_top/axi_slave/u_dct_compute/reset_n
add wave -noupdate -expand -group DCT /hdl_top/axi_slave/u_dct_compute/start
add wave -noupdate -expand -group DCT /hdl_top/axi_slave/u_dct_compute/done
add wave -noupdate -expand -group DCT /hdl_top/axi_slave/u_dct_compute/state
add wave -noupdate -expand -group DCT /hdl_top/axi_slave/u_dct_compute/idx
add wave -noupdate -expand /hdl_top/axi_slave/u_dct_compute/in_block
add wave -noupdate /hdl_top/axi_slave/u_dct_compute/out_block
TreeUpdate [SetDefaultTree]
WaveRestoreCursors {{Cursor 1} {450 ns} 0}
quietly wave cursor active 1
configure wave -namecolwidth 150
configure wave -valuecolwidth 136
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
WaveRestoreZoom {260 ns} {524 ns}
