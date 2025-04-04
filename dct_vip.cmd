// Version '20210701'
// Library '2021.3_2:09/26/2021:08:26'
"Configurator" create VIP_instance 2021.3_2/amba/axi4 /top/axi4_master_0 axi4_master  
"Configurator" import /root/Documents/BSC/Master/AIPD/lab4/aipcd-lab4/axi_slave_64bits.sv
"Configurator" change port connection /top/axi_slave/clk /top/default_clk_gen_CLK
"Configurator" change port connection /top/axi_slave/reset_n /top/default_reset_gen_RESET
"Configurator" change port connection /top/axi_slave/awvalid /top/axi4_master_0_AWVALID
"Configurator" change port connection /top/axi_slave/awaddr /top/axi4_master_0_AWADDR
"Configurator" change port connection /top/axi_slave/awlen /top/axi4_master_0_AWLEN
"Configurator" change port connection /top/axi_slave/awsize /top/axi4_master_0_AWSIZE
"Configurator" change port connection /top/axi_slave/awburst /top/axi4_master_0_AWBURST
"Configurator" change port connection /top/axi_slave/awid /top/axi4_master_0_AWID
"Configurator" change port connection /top/axi_slave/arvalid /top/axi4_master_0_ARVALID
"Configurator" change port connection /top/axi_slave/araddr /top/axi4_master_0_ARADDR
"Configurator" change port connection /top/axi_slave/arsize /top/axi4_master_0_ARSIZE
"Configurator" change port connection /top/axi_slave/arburst /top/axi4_master_0_ARBURST
"Configurator" change port connection /top/axi_slave/arid /top/axi4_master_0_ARID
"Configurator" change port connection /top/axi_slave/wdata /top/axi4_master_0_WDATA
"Configurator" change port connection /top/axi_slave/wstrb /top/axi4_master_0_WSTRB
"Configurator" change port connection /top/axi_slave/wlast /top/axi4_master_0_WLAST
"Configurator" change port connection /top/axi_slave/wvalid /top/axi4_master_0_WVALID
"Configurator" change port connection /top/axi_slave/bready /top/axi4_master_0_BREADY
"Configurator" change port connection /top/axi_slave/arlen /top/axi4_master_0_ARLEN
"Configurator" change port connection /top/axi_slave/rready /top/axi4_master_0_RREADY
"Configurator" change port connection /top/axi4_master_0/AWREADY /top/axi_slave_awready
"Configurator" change port connection /top/axi4_master_0/WREADY /top/axi_slave_wready
"Configurator" change port connection /top/axi4_master_0/BID /top/axi_slave_bid
"Configurator" change port connection /top/axi4_master_0/BRESP /top/axi_slave_bresp
"Configurator" change port connection /top/axi4_master_0/BVALID /top/axi_slave_bvalid
"Configurator" change port connection /top/axi4_master_0/ARREADY /top/axi_slave_arready
"Configurator" change port connection /top/axi4_master_0/RID /top/axi_slave_rid
"Configurator" change port connection /top/axi4_master_0/RDATA /top/axi_slave_rdata
"Configurator" change port connection /top/axi4_master_0/RRESP /top/axi_slave_rresp
"Configurator" change port connection /top/axi4_master_0/RLAST /top/axi_slave_rlast
"Configurator" change port connection /top/axi4_master_0/RVALID /top/axi_slave_rvalid
"Configurator" change instance /top/axi4_master_0 rtl
"Configurator" address_map create DCT
"Configurator" address_map DCT add MAP_NORMAL,"CTRL",0,MAP_NS,4'h0,64'h0,64'h4,MEM_NORMAL,MAP_NORM_SEC_DATA
"Configurator" address_map DCT add MAP_NORMAL,"STATUS",0,MAP_NS,4'h0,64'h4,64'h4,MEM_NORMAL,MAP_NORM_SEC_DATA
"Configurator" address_map DCT add MAP_NORMAL,"IN_BLOCK",0,MAP_NS,4'h0,64'h8,64'h200,MEM_NORMAL,MAP_NORM_SEC_DATA
"Configurator" address_map DCT add MAP_NORMAL,"OUT_BLOCK",0,MAP_NS,4'h0,64'h208,64'h200,MEM_NORMAL,MAP_NORM_SEC_DATA
"Configurator" change variable vip_config.addr_map DCT
"Configurator" change hash_param RDATA_WIDTH 64
"Configurator" change hash_param WDATA_WIDTH 64
"Configurator" sequence add axi4_master_0 axi4lite_wr_data_deparam_seq
"Configurator" sequence add axi4_master_0 axi4lite_wr_data_deparam_seq 0
"Configurator" sequence add axi4_master_0 axi4lite_rd_data_deparam_seq 1
"Configurator" sequence add axi4_master_0 axi4lite_rd_data_deparam_seq 2
