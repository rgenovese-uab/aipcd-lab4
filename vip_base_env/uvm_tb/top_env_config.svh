//
// File: top_env_config.svh
//
// Generated from Mentor VIP Configurator (20210701)
// Generated using Mentor VIP Library ( 2021.3_2 : 09/26/2021:08:26 )
//
class top_env_config extends uvm_object;
    `uvm_object_utils(top_env_config)
    // Handles for vip config for each of the QVIP instances
    
    axi4_master_0_cfg_t axi4_master_0_cfg;
    // Handles for address maps
    
    address_map DCT;
    
    function new
    (
        string name = "top_env_config"
    );
        super.new(name);
    endfunction
    
    extern function void initialize;
    
endclass: top_env_config

function void top_env_config::initialize;
    begin
        addr_map_entry_s addr_map_entries[] = new [4];
        addr_map_entries = '{'{MAP_NORMAL,"CTRL",0,MAP_NS,4'h0,64'h0,64'h4,MEM_NORMAL,MAP_NORM_SEC_DATA},'{MAP_NORMAL,"STATUS",0,MAP_NS,4'h0,64'h4,64'h4,MEM_NORMAL,MAP_NORM_SEC_DATA},'{MAP_NORMAL,"IN_BLOCK",0,MAP_NS,4'h0,64'h8,64'h200,MEM_NORMAL,MAP_NORM_SEC_DATA},'{MAP_NORMAL,"OUT_BLOCK",0,MAP_NS,4'h0,64'h208,64'h200,MEM_NORMAL,MAP_NORM_SEC_DATA}};
        DCT = address_map::type_id::create("DCT_addr_map");
        DCT.addr_mask = 64'h3;
        DCT.set( addr_map_entries );
    end
endfunction: initialize

