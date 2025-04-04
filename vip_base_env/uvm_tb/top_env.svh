//
// File: top_env.svh
//
// Generated from Mentor VIP Configurator (20210701)
// Generated using Mentor VIP Library ( 2021.3_2 : 09/26/2021:08:26 )
//
`include "uvm_macros.svh"
class top_env extends uvm_env;
    `uvm_component_utils(top_env)
    top_env_config cfg;
    // Agent handles
    
    axi4_master_0_agent_t axi4_master_0;
    scoreboard dct_scoreboard;
    function new
    (
        string name = "top_env",
        uvm_component parent = null
    );
        super.new(name, parent);
    endfunction
    
    extern function void build_phase
    (
        uvm_phase phase
    );

    extern function void connect_phase
    (
        uvm_phase phase
    );
    
endclass: top_env

function void top_env::build_phase
(
    uvm_phase phase
);
    if ( cfg == null )
    begin
        if ( !uvm_config_db #(top_env_config)::get(this, "", "env_config", cfg) )
        begin
            `uvm_error("build_phase", "Unable to find the env config object in the uvm_config_db")
        end
    end
    axi4_master_0 = axi4_master_0_agent_t::type_id::create("axi4_master_0", this );
    axi4_master_0.set_mvc_config(cfg.axi4_master_0_cfg);

    dct_scoreboard = scoreboard::type_id::create("dct_scoreboard", this);
    
endfunction: build_phase

function void top_env::connect_phase
(
    uvm_phase phase
);
   cfg.ap.connect(dct_scoreboard.ap_imp);
    
endfunction: connect_phase

