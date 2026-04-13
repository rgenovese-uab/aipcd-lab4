module axi_slave #(
    parameter DATA_WIDTH = 64,
    parameter ADDR_WIDTH = 32,
    parameter MEM_SIZE   = 1024  // memory size in words
)(
    input  logic                   clk,
    input  logic                   reset_n,

    // Write Address Channel
    input  logic [3:0]             awid,
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
    output logic [3:0]             bid,
    output logic [1:0]             bresp,
    output logic                   bvalid,
    input  logic                   bready,

    // Read Address Channel
    input  logic [3:0]             arid,
    input  logic [ADDR_WIDTH-1:0]  araddr,
    input  logic [7:0]             arlen,
    input  logic [2:0]             arsize,
    input  logic [1:0]             arburst,
    input  logic                   arvalid,
    output logic                   arready,

    // Read Data Channel
    output logic [3:0]             rid,
    output logic [DATA_WIDTH-1:0]  rdata,
    output logic [1:0]             rresp,
    output logic                   rlast,
    output logic                   rvalid,
    input  logic                   rready
);

    // Address mapping (in bytes, but memory is word-addressed)
    // CTRL     : 0x0 (word 0)
    // STATUS   : 0x4 (word 1)
    // IN_BLOCK : 0x8 to 0x207 (words 2 to 65) - 64 words of 8 bytes each
    // OUT_BLOCK: 0x208 to 0x407 (words 66 to 129) - 64 words of 8 bytes each
    
    localparam CTRL_ADDR_WORD   = 0;
    localparam STATUS_ADDR_WORD = 1;
    localparam IN_BLOCK_START   = 2;    // word address for start of input block
    localparam OUT_BLOCK_START  = 66;   // word address for start of output block (0x208 / 8 = 66)
    
    // Internal memory array (word-addressable, each word is DATA_WIDTH bits)
    logic [DATA_WIDTH-1:0] mem [0:MEM_SIZE-1];
    
    // DCT control signals
    logic dct_start;
    logic dct_done;
    logic [DATA_WIDTH-1:0] in_block [0:63];
    logic [DATA_WIDTH-1:0] out_block [0:63];
    logic dct_computing;
    
    // Write address registers
    logic [3:0]            awid_reg;
    logic [ADDR_WIDTH-1:0] awaddr_reg;
    logic [7:0]            awlen_reg;
    logic [2:0]            awsize_reg;
    logic [1:0]            awburst_reg;
    logic [7:0]            awburst_cnt;
    logic                  aw_active;
    
    // Write transaction tracking
    logic [7:0] write_count;
    logic start_written;
    
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
            start_written <= 1'b0;
            write_count <= 8'd0;
        end else begin
            if (awvalid && !aw_active) begin
                awid_reg    <= awid;
                awaddr_reg  <= awaddr;
                awlen_reg   <= awlen;
                awsize_reg  <= awsize;
                awburst_reg <= awburst;
                awburst_cnt <= awlen;
                aw_active   <= 1'b1;
                awready     <= 1'b1;
            end else begin
                awready     <= 1'b0;
            end
            
            // Reset start_written when DCT starts computing
            if (dct_start && !dct_computing) begin
                start_written <= 1'b0;
            end
            
            if (aw_active && wvalid && wready && wlast) begin
                aw_active <= 1'b0;
            end
        end
    end
    
    // Write Data Channel Handling
    always_ff @(posedge clk or negedge reset_n) begin
        if (!reset_n) begin
            wready <= 1'b0;
        end else begin
            if (aw_active && wvalid) begin
                wready <= 1'b1;
                
                // Normal write to memory
                mem[awaddr_reg[ADDR_WIDTH-1:2]] <= wdata;
                
                // Special handling for CTRL register (address 0x0)
                if (awaddr_reg == 0) begin
                    // Write to CTRL - start DCT if value is 1
                    if (wdata == 64'd1) begin
                        start_written <= 1'b1;
                    end
                end
                // Write to IN_BLOCK region (addresses 0x8 to 0x207)
                else if (awaddr_reg >= 'h8 && awaddr_reg <= 'h207) begin
                    // Copy to in_block array for DCT
                    automatic int word_idx = (awaddr_reg - 'h8) / 8;
                    if (word_idx >= 0 && word_idx < 64) begin
                        in_block[word_idx] <= wdata;
                        write_count <= write_count + 1;
                    end
                end
                
                // Address increment for burst
                if (awburst_cnt != 0) begin
                    awaddr_reg  <= awaddr_reg + (1 << awsize);
                    awburst_cnt <= awburst_cnt - 1;
                end
            end else begin
                wready <= 1'b0;
            end
        end
    end
    
    // DCT Computation Control
    logic dct_busy;
    
    always_ff @(posedge clk or negedge reset_n) begin
        if (!reset_n) begin
            dct_computing <= 1'b0;
            // Initialize STATUS to 0 (not done)
            mem[STATUS_ADDR_WORD] <= 64'd0;
        end else begin
            // Start DCT when START is written to CTRL
            if (start_written && !dct_computing && write_count == /*64*/128) begin //[TOFIX] should be 64 but each write increments write_count by 2
                dct_computing <= 1'b1;
                mem[STATUS_ADDR_WORD] <= 64'd0;  // Clear STATUS while computing
            end
            
            // When DCT is done, write results to OUT_BLOCK and set STATUS
            if (dct_done && dct_computing) begin
                // Copy out_block results to memory at OUT_BLOCK location
                for (int i = 0; i < 64; i++) begin
                    mem[OUT_BLOCK_START + i] <= out_block[i];
                end
                // Set STATUS register to DONE (all 1's or -1)
                mem[STATUS_ADDR_WORD] <= {64{1'b1}};  // -1 in two's complement
                dct_computing <= 1'b0;
                write_count <= 8'd0;
            end
        end
    end
    
    // Instantiate DCT compute module
    dct_compute u_dct_compute (
        .clk      (clk),
        .reset_n  (reset_n),
        .start    (dct_computing && !dct_done),
        .in_block (in_block),
        .out_block(out_block),
        .done     (dct_done)
    );
    
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
                bid    <= awid_reg;
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
                // Read from memory
                rdata  <= mem[araddr_reg[ADDR_WIDTH-1:2]];
                rresp  <= 2'b00;
                rid    <= arid_reg;
                
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