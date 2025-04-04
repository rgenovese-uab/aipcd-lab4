export TOP_DIR_NAME=$(pwd)

export TOP_DUT_DIR_NAME=$(pwd)

-f top_test_filelist.f +incdir+${QUESTA_MVC_HOME}/questa_mvc_src/sv
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
