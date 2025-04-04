module axi_slave #(
    parameter DATA_WIDTH = 64,
    parameter ADDR_WIDTH = 32,
    parameter MEM_SIZE   = 1024  // memory size in words
)(
    input  logic                   clk,
    input  logic                   reset_n,

    // Write Address Channel
    input  logic [3:0]             awid,      // Example: 4-bit ID
    input  logic [ADDR_WIDTH-1:0]  awaddr,
    input  logic [7:0]             awlen,
    input  logic [2:0]             awsize,
    input  logic [1:0]             awburst,
    input  logic                   awvalid,
    output logic                   awready,

    // Write Data Channel
    input  logic [DATA_WIDTH-1:0]  wdata,
    input  logic [(DATA_WIDTH/8)-1:0] wstrb,
    input  logic                   wlast,
    input  logic                   wvalid,
    output logic                   wready,

    // Write Response Channel
    output logic [3:0]             bid,       // Write response ID
    output logic [1:0]             bresp,
    output logic                   bvalid,
    input  logic                   bready,

    // Read Address Channel
    input  logic [3:0]             arid,      // Read address ID
    input  logic [ADDR_WIDTH-1:0]  araddr,
    input  logic [7:0]             arlen,
    input  logic [2:0]             arsize,
    input  logic [1:0]             arburst,
    input  logic                   arvalid,
    output logic                   arready,

    // Read Data Channel
    output logic [3:0]             rid,       // Read response ID
    output logic [DATA_WIDTH-1:0]  rdata,
    output logic [1:0]             rresp,
    output logic                   rlast,
    output logic                   rvalid,
    input  logic                   rready
);

    // Internal memory array (word-addressable)
    logic [DATA_WIDTH-1:0] mem [0:MEM_SIZE-1];

    // Write address registers
    logic [3:0]            awid_reg;
    logic [ADDR_WIDTH-1:0] awaddr_reg;
    logic [7:0]            awlen_reg;
    logic [2:0]            awsize_reg;
    logic [1:0]            awburst_reg;
    logic [7:0]            awburst_cnt;
    logic                  aw_active;

    // Read address registers
    logic [3:0]            arid_reg;
    logic [ADDR_WIDTH-1:0] araddr_reg;
    logic [7:0]            arlen_reg;
    logic [2:0]            arsize_reg;
    logic [1:0]            arburst_reg;
    logic [7:0]            arburst_cnt;
    logic                  ar_active;

    // Write Address Channel Handling
    always_ff @(posedge clk or negedge reset_n) begin
        if (!reset_n) begin
            awready     <= 1'b0;
            aw_active   <= 1'b0;
            awburst_cnt <= 8'd0;
        end else begin
            if (awvalid && !aw_active) begin
                awid_reg    <= awid;
                awaddr_reg  <= awaddr;
                awlen_reg   <= awlen;
                awsize_reg  <= awsize;
                awburst_reg <= awburst;
                awburst_cnt <= awlen;  // Number of additional beats in burst
                aw_active   <= 1'b1;
                awready     <= 1'b1;
            end else begin
                awready     <= 1'b0;
            end

            if (aw_active && wvalid && wready && wlast) begin
                aw_active <= 1'b0;
            end
        end
    end

    logic [ADDR_WIDTH-1:0] aux_awaddr_reg;
    assign aux_awaddr_reg = awaddr_reg[ADDR_WIDTH-1:2];

    // Write Data Channel Handling
    always_ff @(posedge clk or negedge reset_n) begin
        if (!reset_n) begin
            wready <= 1'b0;
            mem[1] <= 4'h0; //FAKE STATUS NOT DONE
        end else begin
            if (aw_active && wvalid) begin
                wready <= 1'b1;
                mem[awaddr_reg[ADDR_WIDTH-1:2]] <= wdata;
                //$display("AXI SLAVE - WRITE ADDR %d VALUE %h AWADDR %d ",awaddr_reg[ADDR_WIDTH-1:2], wdata, awaddr_reg);
                if( awaddr!= 0) begin //copy only data, not ctrl
                    mem['h80 + awaddr_reg[ADDR_WIDTH-1:2]] <= wdata; // COPY IN_VALUE TO OUT_VALUE 
                    //$display("AXI SLAVE - COPY ADDR %d VALUE %h AWADDR %d ",'h80 +awaddr_reg[ADDR_WIDTH-1:2], wdata, 'h80 +awaddr_reg);
                end
                if(awaddr_reg[ADDR_WIDTH-1:2] == 'h80) //LAST VALUE WAS WRITTEN
                    mem[1] <= -1; //FAKE STATUS DONE
                if (awburst_cnt != 0) begin
                    awaddr_reg  <= awaddr_reg + (1 << awsize);
                    awburst_cnt <= awburst_cnt - 1;
                end
            end else begin
                wready <= 1'b0;
            end
        end
    end

    // Write Response Channel Handling
    always_ff @(posedge clk or negedge reset_n) begin
        if (!reset_n) begin
            bvalid <= 1'b0;
            bresp  <= 2'b00;
            bid    <= 4'b0;
        end else begin
            if (!bvalid && aw_active && wvalid && wready && wlast) begin
                bvalid <= 1'b1;
                bresp  <= 2'b00;  // OKAY response
                bid    <= awid_reg; // Echo the ID
            end else if (bvalid && bready) begin
                bvalid <= 1'b0;
            end
        end
    end

    // Read Address Channel Handling
    always_ff @(posedge clk or negedge reset_n) begin
        if (!reset_n) begin
            arready     <= 1'b0;
            ar_active   <= 1'b0;
            arburst_cnt <= 8'd0;
        end else begin
            if (arvalid && !ar_active) begin
                arid_reg    <= arid;
                araddr_reg  <= araddr;
                arlen_reg   <= arlen;
                arsize_reg  <= arsize;
                arburst_reg <= arburst;
                arburst_cnt <= arlen;
                ar_active   <= 1'b1;
                arready     <= 1'b1;
            end else begin
                arready     <= 1'b0;
            end
        end
    end

    // Read Data Channel Handling
    always_ff @(posedge clk or negedge reset_n) begin
        if (!reset_n) begin
            rvalid <= 1'b0;
            rdata  <= {DATA_WIDTH{1'b0}};
            rresp  <= 2'b00;
            rlast  <= 1'b0;
            rid    <= 4'b0;
        end else begin
            if (ar_active && (!rvalid || (rvalid && rready))) begin
                rvalid <= 1'b1;
                rdata  <= mem[araddr_reg[ADDR_WIDTH-1:2]];
                //$display("AXI SLAVE - READ ADDR %d VALUE %h ARADDR %d ",araddr_reg[ADDR_WIDTH-1:2], mem[araddr_reg[ADDR_WIDTH-1:2]], araddr_reg);
                rresp  <= 2'b00; // OKAY
                rid    <= arid_reg; // Echo the ID
                if (arburst_cnt == 0) begin
                    rlast    <= 1'b1;
                    ar_active <= 1'b0;
                end else begin
                    rlast    <= 1'b0;
                    araddr_reg  <= araddr_reg + (1 << arsize);
                    arburst_cnt <= arburst_cnt - 1;
                end
            end else if (rvalid && rready && rlast) begin
                rvalid <= 1'b0;
                rlast  <= 1'b0;
            end
        end
    end

endmodule
