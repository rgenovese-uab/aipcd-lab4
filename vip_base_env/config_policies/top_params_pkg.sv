//
// File: top_params_pkg.sv
//
// Generated from Mentor VIP Configurator (20210701)
// Generated using Mentor VIP Library ( 2021.3_2 : 09/26/2021:08:26 )
//
package top_params_pkg;
    import addr_map_pkg::*;
    import rw_delay_db_pkg::*;
    //
    // Import the necessary QVIP packages:
    //
    import mgc_axi4_v1_0_pkg::*;
    import mgc_axi4lite_seq_pkg::*;
    class axi_slave_params;
        localparam int DATA_WIDTH = 64;
        localparam int ADDR_WIDTH = 32;
        localparam int MEM_SIZE   = 1024;
    endclass: axi_slave_params
    
    class axi4_master_0_params;
        localparam int AXI4_ADDRESS_WIDTH   = 32;
        localparam int AXI4_RDATA_WIDTH     = 64;
        localparam int AXI4_WDATA_WIDTH     = 64;
        localparam int AXI4_ID_WIDTH        = 4;
        localparam int AXI4_USER_WIDTH      = 4;
        localparam int AXI4_REGION_MAP_SIZE = 16;
    endclass: axi4_master_0_params
    
    typedef axi4_vip_config #(axi4_master_0_params::AXI4_ADDRESS_WIDTH,axi4_master_0_params::AXI4_RDATA_WIDTH,axi4_master_0_params::AXI4_WDATA_WIDTH,axi4_master_0_params::AXI4_ID_WIDTH,axi4_master_0_params::AXI4_USER_WIDTH,axi4_master_0_params::AXI4_REGION_MAP_SIZE) axi4_master_0_cfg_t;
    
    typedef axi4_agent #(axi4_master_0_params::AXI4_ADDRESS_WIDTH,axi4_master_0_params::AXI4_RDATA_WIDTH,axi4_master_0_params::AXI4_WDATA_WIDTH,axi4_master_0_params::AXI4_ID_WIDTH,axi4_master_0_params::AXI4_USER_WIDTH,axi4_master_0_params::AXI4_REGION_MAP_SIZE) axi4_master_0_agent_t;
    
    typedef virtual mgc_axi4 #(axi4_master_0_params::AXI4_ADDRESS_WIDTH,axi4_master_0_params::AXI4_RDATA_WIDTH,axi4_master_0_params::AXI4_WDATA_WIDTH,axi4_master_0_params::AXI4_ID_WIDTH,axi4_master_0_params::AXI4_USER_WIDTH,axi4_master_0_params::AXI4_REGION_MAP_SIZE) axi4_master_0_bfm_t;
    
    //
    // `includes for the config policy classes:
    //
    `include "axi4_master_0_config_policy.svh"
endpackage: top_params_pkg
