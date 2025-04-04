import "DPI-C" function int  dct(input real in_block[8][8], output real out_block[8][8]);

class scoreboard extends uvm_scoreboard;
    `uvm_component_utils (scoreboard)

    function new (string name = "scoreboard", uvm_component parent);
        super.new (name, parent);
    endfunction

    uvm_analysis_imp #(dct_transaction, scoreboard) ap_imp;

    function void build_phase (uvm_phase phase);
        ap_imp = new ("ap_imp", this);
    endfunction

    virtual function void write (dct_transaction data);
        real out_ref[8][8];
        int row, col;
        // What should be done with the data packet received comes here - let's display it
        `uvm_info ("write", $sformatf("Data received = 0x%0h", data), UVM_MEDIUM)

        $display("CALL DCT - IN[0][0]=%f - IN[7][7]=%f", data.in[0][0], data.in[7][7]);
        dct(data.in, out_ref);
        $display("CALLED DCT - OUT_REF[0][0]=%f - OUT_REF[7][7]=%f", out_ref[0][0], out_ref[7][7]);

        //Compare input == output
        for (row = 0; row < 8; row++) begin
            for (col = 0; col < 8; col++) begin
                if(data.in[row][col] != data.out[row][col])
                    $uvm_fatal("AXI4LITE SEQ","ERROR COMPARING IN==OUT");
                else
                    $display("IN[%d][%d]=%h == OUT[%d][%d]=%h",row, col, data.in[row][col], row, col, data.out[row][col]);
            end
        end
    endfunction

endclass