//
// File: default_clk_gen.sv
//
// Generated from Mentor VIP Configurator (20210701)
// Generated using Mentor VIP Library ( 2021.3_2 : 09/26/2021:08:26 )
//
module default_clk_gen
(
    output reg  CLK
);
    
    timeunit 1ns;
    timeprecision 1ns;
    
    initial
    begin
        CLK = 0;
        forever
        begin
            #1 CLK = ~CLK;
        end
    end
    

endmodule: default_clk_gen
