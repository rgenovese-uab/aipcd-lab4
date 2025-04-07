//
// File: top_vseq_base.svh
//
// Generated from Mentor VIP Configurator (20210701)
// Generated using Mentor VIP Library ( 2021.3_2 : 09/26/2021:08:26 )
//
class top_vseq_base extends uvm_sequence;
    `uvm_object_utils(top_vseq_base)
    // Handles for each of the target (QVIP) sequencers
    
    mvc_sequencer axi4_master_0;
    top_env_config env_cfg;
    uvm_analysis_port #(dct_transaction) ap_db;
    
    function new
    (
        string name = "top_vseq_base"
    );
        super.new(name);
    endfunction
    
    task body;
    endtask: body

    // Called before the body() task
    task pre_body ();
        if(!uvm_config_db #(uvm_analysis_port#(dct_transaction))::get(null, "*", "ap_db", ap_db)) begin
            `uvm_error(get_type_name(), "No uvm_analysis_port in DB")
        end
    endtask
    
endclass: top_vseq_base

