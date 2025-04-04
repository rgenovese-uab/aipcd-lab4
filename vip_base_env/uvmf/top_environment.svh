//
// File: top_environment.svh
//
// Generated from Mentor VIP Configurator (20210701)
// Generated using Mentor VIP Library ( 2021.3_2 : 09/26/2021:08:26 )
//
`include "uvm_macros.svh"
class top_environment extends uvmf_environment_base #(.CONFIG_T(top_env_configuration));
    `uvm_component_utils(top_environment)
    // Agent handles
    
    axi4_master_0_agent_t axi4_master_0;
    function new
    (
        string name = "top_environment",
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
    
endclass: top_environment

function void top_environment::build_phase
(
    uvm_phase phase
);
    axi4_master_0 = axi4_master_0_agent_t::type_id::create("axi4_master_0", this );
    axi4_master_0.set_mvc_config(configuration.axi4_master_0_cfg);
    
endfunction: build_phase

function void top_environment::connect_phase
(
    uvm_phase phase
);
    uvm_config_db #(mvc_sequencer)::set(null,UVMF_SEQUENCERS,"axi4_master_0",axi4_master_0.m_sequencer);
endfunction: connect_phase

