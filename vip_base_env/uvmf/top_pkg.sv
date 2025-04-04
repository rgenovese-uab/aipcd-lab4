//
// File: top_pkg.sv
//
// Generated from Mentor VIP Configurator (20210701)
// Generated using Mentor VIP Library ( 2021.3_2 : 09/26/2021:08:26 )
//
// ## The following code is used to add this qvip_configurator generated output into an
// ## encapsulating UVMF Generated environment.  The addQvipSubEnv function is added to 
// ## the python configuration file used by the UVMF environment generator.
// env.addQvipSubEnv('sub_env_instance_name', 'top', ['axi4_master_0'])
//
// ## The following code is used to add this qvip_configurator generated output into an
// ## encapsulating UVMF Generated test bench.  The addQvipBfm function is added to 
// ## the python configuration file used by the UVMF bench generator.
// ben.addQvipBfm('axi4_master_0', 'top', 'ACTIVE')
package top_pkg;
    import uvm_pkg::*;
    
    `include "uvm_macros.svh"
    
    import addr_map_pkg::*;
    
    import uvmf_base_pkg::*;
    import top_params_pkg::*;
    import mvc_pkg::*;
    import mgc_axi4lite_seq_pkg::*;
    import mgc_axi4_v1_0_pkg::*;
    
    `include "top_env_configuration.svh"
    `include "top_environment.svh"
endpackage: top_pkg
