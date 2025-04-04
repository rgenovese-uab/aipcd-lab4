//
// File: top_example_vseq.svh
//
// Generated from Mentor VIP Configurator (20210701)
// Generated using Mentor VIP Library ( 2021.3_2 : 09/26/2021:08:26 )
//
// The purpose of this example virtual sequence is to show how the default or selected sequences for 
// each QVIP can be run. The sequences are run in series in an arbitary order. 

import "DPI-C" function int  dct(input real in_block[8][8], output real out_block[8][8]);

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
    
    real in[8][8];
    real out[8][8], out_ref[8][8];

    // Sequences run in the following order
    
    // Sequences run in the following order    
    begin
        fork 
            begin
                int  row, col, idx;
                logic [63:0] temp;
                byte wr_data[64*8];
                //Write input values
                //axi4_master_0_seq_0.addr = 'h8;
                //axi4_master_0_seq_0.wr_data = new[64*8]; //64 values of 8 bytes each

                // Generate random real values and store in 'in' matrix
                for (row = 0; row < 8; row++) begin
                    for (col = 0; col < 8; col++) begin
                        in[row][col] = $urandom_range(1,100)/100.0 + $random % 100; // Example range
                        //$display("IN[%d][%d]=%f",row, col, in[row][col]);
                    end
                end

                // Convert each real value to 64-bit representation and store in wr_data
                for (row = 0; row < 8; row++) begin
                    for (col = 0; col < 8; col++) begin
                        idx = (row * 8 + col) * 8; // Calculate base index in wr_data
                        temp = $realtobits(in[row][col]); // Convert real to 64-bit IEEE 754
                        //$display("TEMP IN[%d] = %h",idx, temp);
                        wr_data[idx]   = temp[7:0];   
                        wr_data[idx+1] = temp[15:8];  
                        wr_data[idx+2] = temp[23:16]; 
                        wr_data[idx+3] = temp[31:24]; 
                        wr_data[idx+4] = temp[39:32]; 
                        wr_data[idx+5] = temp[47:40]; 
                        wr_data[idx+6] = temp[55:48]; 
                        wr_data[idx+7] = temp[63:56]; // MSB
                    end
                end

                for( int i = 0; i < 64; i++) begin
                    idx = i*8;
                    axi4_master_0_seq_0.addr = 'h8 + idx;
                    axi4_master_0_seq_0.wr_data = {wr_data[idx],wr_data[idx+1],wr_data[idx+2],wr_data[idx+3],wr_data[idx+4],wr_data[idx+5],wr_data[idx+6],wr_data[idx+7]};//{words[i]};
                    //$display("WRITING DATA TO ADDR %h, IDX %d = %h", axi4_master_0_seq_0.addr, idx, axi4_master_0_seq_0.wr_data);
                    axi4_master_0_seq_0.start(axi4_master_0);
                end

                //Start the DCT operation
                axi4_master_0_seq_1.addr = 'h0; //CTRL
                axi4_master_0_seq_1.wr_data = {'h1}; //START
                axi4_master_0_seq_1.start(axi4_master_0);
            end
            begin
                int  row, col, idx;
                logic [63:0] temp = '0;
                //Read STATUS until DCT operation is done
                axi4_master_0_seq_2.addr = 'h4; //STATUS
                axi4_master_0_seq_2.rd_bytes = 'h4; //4bytes
                while( temp == 0 )begin //repeat sequence until STATUS != 0
                    temp = { axi4_master_0_seq_2.rd_data[3], axi4_master_0_seq_2.rd_data[2], 
                             axi4_master_0_seq_2.rd_data[1], axi4_master_0_seq_2.rd_data[0] };
                    axi4_master_0_seq_2.start(axi4_master_0);
                end
                $display("STATUS DONE @%d - VALUE", $time(), axi4_master_0_seq_2.rd_data[0]);

                //Read output values
                for( int i = 0; i < 64; i++) begin
                    idx = i*8;
                    axi4_master_0_seq_3.addr = 'h208 + idx;
                    axi4_master_0_seq_3.rd_bytes = 8; //read 8 bytes 64 times
                    axi4_master_0_seq_3.start(axi4_master_0);

                     // Wait for the transaction to complete before reading the data
                    temp = { axi4_master_0_seq_3.rd_data[7], axi4_master_0_seq_3.rd_data[6], 
                             axi4_master_0_seq_3.rd_data[5], axi4_master_0_seq_3.rd_data[4], 
                             axi4_master_0_seq_3.rd_data[3], axi4_master_0_seq_3.rd_data[2], 
                             axi4_master_0_seq_3.rd_data[1], axi4_master_0_seq_3.rd_data[0] };

                    // Convert to real and store in the output matrix
                    out[i/8][i%8] = $bitstoreal(temp);
                end

                $display("CALL DCT - IN[0][0]=%f - IN[7][7]=%f", in[0][0], in[7][7]);
                dct(in, out_ref);
                $display("CALLED DCT - OUT_REF[0][0]=%f - OUT_REF[7][7]=%f", out_ref[0][0], out_ref[7][7]);


                //Compare input == output
                for (row = 0; row < 8; row++) begin
                    for (col = 0; col < 8; col++) begin
                        if(in[row][col] != out[row][col])
                            $uvm_fatal("AXI4LITE SEQ","ERROR COMPARING IN==OUT");
                        else
                            $display("IN[%d][%d]=%h == OUT[%d][%d]=%h",row, col, in[row][col], row, col, out[row][col]);
                    end
                end



            end
        join
    end
endtask: body

