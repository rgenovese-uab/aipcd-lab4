`include "uvm_macros.svh"

class dct_transaction extends uvm_sequence_item;
    `uvm_object_utils(dct_transaction)

    real in[8][8];
    real out[8][8];

    function new(string name = "dct_transaction");
        super.new(name);
    endfunction : new

    virtual function void do_print(uvm_printer printer);
        super.do_print(printer);
            //printer.print_int("iss_state", iss_state, $bits(iss_state.instr));
    endfunction : do_print

endclass : dct_transaction