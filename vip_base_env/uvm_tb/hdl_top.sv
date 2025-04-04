//
// File: hdl_top.sv
//
// Generated from Mentor VIP Configurator (20210701)
// Generated using Mentor VIP Library ( 2021.3_2 : 09/26/2021:08:26 )
//
//Time resolution of '1ns' will be used (See Makefiles and scripts)
module hdl_top;
    import uvm_pkg::*;
    import top_params_pkg::*;
    wire                                                          default_clk_gen_CLK;
    wire                                                          default_reset_gen_RESET;
    wire                                                          axi4_master_0_AWVALID;
    wire [axi4_master_0_params::AXI4_ADDRESS_WIDTH-1:0]           axi4_master_0_AWADDR;
    wire [2:0]                                                    axi4_master_0_AWPROT;
    wire [3:0]                                                    axi4_master_0_AWREGION;
    wire [7:0]                                                    axi4_master_0_AWLEN;
    wire [((axi4_master_0_params::AXI4_WDATA_WIDTH==2048)?3:2):0] axi4_master_0_AWSIZE;
    wire [1:0]                                                    axi4_master_0_AWBURST;
    wire                                                          axi4_master_0_AWLOCK;
    wire [3:0]                                                    axi4_master_0_AWCACHE;
    wire [3:0]                                                    axi4_master_0_AWQOS;
    wire [axi4_master_0_params::AXI4_ID_WIDTH-1:0]                axi4_master_0_AWID;
    wire [axi4_master_0_params::AXI4_USER_WIDTH-1:0]              axi4_master_0_AWUSER;
    wire                                                          axi4_master_0_ARVALID;
    wire [axi4_master_0_params::AXI4_ADDRESS_WIDTH-1:0]           axi4_master_0_ARADDR;
    wire [2:0]                                                    axi4_master_0_ARPROT;
    wire [3:0]                                                    axi4_master_0_ARREGION;
    wire [7:0]                                                    axi4_master_0_ARLEN;
    wire [((axi4_master_0_params::AXI4_RDATA_WIDTH==2048)?3:2):0] axi4_master_0_ARSIZE;
    wire [1:0]                                                    axi4_master_0_ARBURST;
    wire                                                          axi4_master_0_ARLOCK;
    wire [3:0]                                                    axi4_master_0_ARCACHE;
    wire [3:0]                                                    axi4_master_0_ARQOS;
    wire [axi4_master_0_params::AXI4_ID_WIDTH-1:0]                axi4_master_0_ARID;
    wire [axi4_master_0_params::AXI4_USER_WIDTH-1:0]              axi4_master_0_ARUSER;
    wire [axi4_master_0_params::AXI4_USER_WIDTH-1:0]              axi4_master_0_RUSER;
    wire                                                          axi4_master_0_RREADY;
    wire                                                          axi4_master_0_WVALID;
    wire [axi4_master_0_params::AXI4_WDATA_WIDTH-1:0]             axi4_master_0_WDATA;
    wire [(axi4_master_0_params::AXI4_WDATA_WIDTH/8)-1:0]         axi4_master_0_WSTRB;
    wire                                                          axi4_master_0_WLAST;
    wire [axi4_master_0_params::AXI4_USER_WIDTH-1:0]              axi4_master_0_WUSER;
    wire [axi4_master_0_params::AXI4_USER_WIDTH-1:0]              axi4_master_0_BUSER;
    wire                                                          axi4_master_0_BREADY;
    wire logic                                                          axi_slave_awready;
    wire logic                                                          axi_slave_wready;
    wire logic [3:0]                                                    axi_slave_bid;
    wire logic [1:0]                                                    axi_slave_bresp;
    wire logic                                                          axi_slave_bvalid;
    wire logic                                                          axi_slave_arready;
    wire logic [3:0]                                                    axi_slave_rid;
    wire logic [axi_slave_params::DATA_WIDTH-1:0]                       axi_slave_rdata;
    wire logic [1:0]                                                    axi_slave_rresp;
    wire logic                                                          axi_slave_rlast;
    wire logic                                                          axi_slave_rvalid;
    
    axi_slave 
    #(
        .DATA_WIDTH(64),
        .ADDR_WIDTH(32),
        .MEM_SIZE(1024)
    )
    axi_slave
    (
        .clk(default_clk_gen_CLK),
        .reset_n(default_reset_gen_RESET),
        .awid(axi4_master_0_AWID),
        .awaddr(axi4_master_0_AWADDR),
        .awlen(axi4_master_0_AWLEN),
        .awsize(axi4_master_0_AWSIZE),
        .awburst(axi4_master_0_AWBURST),
        .awvalid(axi4_master_0_AWVALID),
        .awready(axi_slave_awready),
        .wdata(axi4_master_0_WDATA),
        .wstrb(axi4_master_0_WSTRB),
        .wlast(axi4_master_0_WLAST),
        .wvalid(axi4_master_0_WVALID),
        .wready(axi_slave_wready),
        .bid(axi_slave_bid),
        .bresp(axi_slave_bresp),
        .bvalid(axi_slave_bvalid),
        .bready(axi4_master_0_BREADY),
        .arid(axi4_master_0_ARID),
        .araddr(axi4_master_0_ARADDR),
        .arlen(axi4_master_0_ARLEN),
        .arsize(axi4_master_0_ARSIZE),
        .arburst(axi4_master_0_ARBURST),
        .arvalid(axi4_master_0_ARVALID),
        .arready(axi_slave_arready),
        .rid(axi_slave_rid),
        .rdata(axi_slave_rdata),
        .rresp(axi_slave_rresp),
        .rlast(axi_slave_rlast),
        .rvalid(axi_slave_rvalid),
        .rready(axi4_master_0_RREADY)
    );
    
    axi4_master 
    #(
        .ADDR_WIDTH(axi4_master_0_params::AXI4_ADDRESS_WIDTH),
        .RDATA_WIDTH(axi4_master_0_params::AXI4_RDATA_WIDTH),
        .WDATA_WIDTH(axi4_master_0_params::AXI4_WDATA_WIDTH),
        .ID_WIDTH(axi4_master_0_params::AXI4_ID_WIDTH),
        .USER_WIDTH(axi4_master_0_params::AXI4_USER_WIDTH),
        .REGION_MAP_SIZE(axi4_master_0_params::AXI4_REGION_MAP_SIZE),
        .IF_NAME("axi4_master_0"),
        .PATH_NAME("uvm_test_top")
    )
    axi4_master_0
    (
        .ACLK(default_clk_gen_CLK),
        .ARESETn(default_reset_gen_RESET),
        .AWVALID(axi4_master_0_AWVALID),
        .AWADDR(axi4_master_0_AWADDR),
        .AWPROT(axi4_master_0_AWPROT),
        .AWREGION(axi4_master_0_AWREGION),
        .AWLEN(axi4_master_0_AWLEN),
        .AWSIZE(axi4_master_0_AWSIZE),
        .AWBURST(axi4_master_0_AWBURST),
        .AWLOCK(axi4_master_0_AWLOCK),
        .AWCACHE(axi4_master_0_AWCACHE),
        .AWQOS(axi4_master_0_AWQOS),
        .AWID(axi4_master_0_AWID),
        .AWUSER(axi4_master_0_AWUSER),
        .AWREADY(axi_slave_awready),
        .ARVALID(axi4_master_0_ARVALID),
        .ARADDR(axi4_master_0_ARADDR),
        .ARPROT(axi4_master_0_ARPROT),
        .ARREGION(axi4_master_0_ARREGION),
        .ARLEN(axi4_master_0_ARLEN),
        .ARSIZE(axi4_master_0_ARSIZE),
        .ARBURST(axi4_master_0_ARBURST),
        .ARLOCK(axi4_master_0_ARLOCK),
        .ARCACHE(axi4_master_0_ARCACHE),
        .ARQOS(axi4_master_0_ARQOS),
        .ARID(axi4_master_0_ARID),
        .ARUSER(axi4_master_0_ARUSER),
        .ARREADY(axi_slave_arready),
        .RVALID(axi_slave_rvalid),
        .RDATA(axi_slave_rdata),
        .RRESP(axi_slave_rresp),
        .RLAST(axi_slave_rlast),
        .RID(axi_slave_rid),
        .RUSER(axi4_master_0_RUSER),
        .RREADY(axi4_master_0_RREADY),
        .WVALID(axi4_master_0_WVALID),
        .WDATA(axi4_master_0_WDATA),
        .WSTRB(axi4_master_0_WSTRB),
        .WLAST(axi4_master_0_WLAST),
        .WUSER(axi4_master_0_WUSER),
        .WREADY(axi_slave_wready),
        .BVALID(axi_slave_bvalid),
        .BRESP(axi_slave_bresp),
        .BID(axi_slave_bid),
        .BUSER(axi4_master_0_BUSER),
        .BREADY(axi4_master_0_BREADY)
    );
    default_clk_gen default_clk_gen
    (
        .CLK(default_clk_gen_CLK)
    );
    default_reset_gen default_reset_gen
    (
        .RESET(default_reset_gen_RESET),
        .CLK_IN(default_clk_gen_CLK)
    );

endmodule: hdl_top
