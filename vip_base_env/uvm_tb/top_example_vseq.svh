//
// File: top_example_vseq.svh
//
// Generated from Mentor VIP Configurator (20210701)
// Generated using Mentor VIP Library ( 2021.3_2 : 09/26/2021:08:26 )
//
// The purpose of this example virtual sequence is to show how the default or selected sequences for 
// each QVIP can be run. The sequences are run in series in an arbitary order. 
class top_example_vseq extends top_vseq_base;
    `uvm_object_utils(top_example_vseq)
    function new
    (
        string name = "top_example_vseq"
    );
        super.new(name);
    endfunction
    
    extern task body;
    
endclass: top_example_vseq

task top_example_vseq::body;
    axi4lite_wr_data_deparam_seq axi4_master_0_seq_0 = axi4lite_wr_data_deparam_seq::type_id::create("axi4lite_wr_data_deparam_seq");
    axi4lite_wr_data_deparam_seq axi4_master_0_seq_1 = axi4lite_wr_data_deparam_seq::type_id::create("axi4lite_wr_data_deparam_seq");
    axi4lite_rd_data_deparam_seq axi4_master_0_seq_2 = axi4lite_rd_data_deparam_seq::type_id::create("axi4lite_rd_data_deparam_seq");
    axi4lite_rd_data_deparam_seq axi4_master_0_seq_3 = axi4lite_rd_data_deparam_seq::type_id::create("axi4lite_rd_data_deparam_seq");
    
    // Sequences run in the following order
    
    begin
        axi4_master_0_seq_0.start(axi4_master_0);
        axi4_master_0_seq_1.start(axi4_master_0);
        axi4_master_0_seq_2.start(axi4_master_0);
        axi4_master_0_seq_3.start(axi4_master_0);
    end
endtask: body

