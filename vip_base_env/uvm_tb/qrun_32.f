${QUESTA_MVC_HOME}/include/questa_mvc_svapi.sv
+incdir+${QUESTA_MVC_HOME}/questa_mvc_src/sv +define+MAP_PROT_ATTR ${QUESTA_MVC_HOME}/questa_mvc_src/sv/mvc_pkg.sv
+incdir+${QUESTA_MVC_HOME}/questa_mvc_src/sv+incdir+${QUESTA_MVC_HOME}/questa_mvc_src/sv/axi4 ${QUESTA_MVC_HOME}/questa_mvc_src/sv/axi4/mgc_axi4_v1_0_pkg.sv
+incdir+../config_policies ../config_policies/top_params_pkg.sv
top_pkg.sv
+incdir+${QUESTA_MVC_HOME}/questa_mvc_src/sv/axi4/modules ${QUESTA_MVC_HOME}/questa_mvc_src/sv/axi4/modules/axi4_master.sv
/root/Documents/BSC/Master/AIPD/lab4/aipcd-lab4/axi_slave_64bits.sv
default_clk_gen.sv
default_reset_gen.sv
hdl_top.sv
hvl_top.sv
-debug
-designfile design.bin
-c
-mvchome ${QUESTA_MVC_HOME}
+nowarnTSCALE -t 1ns
-do "run -all; quit"
+UVM_TESTNAME=top_test_base
+SEQ=top_example_vseq
-qwavedb=+signal+transaction+class+uvm_schematic
