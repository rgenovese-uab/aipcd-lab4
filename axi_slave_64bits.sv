module axi_slave #(
    parameter DATA_WIDTH = 64,
    parameter ADDR_WIDTH = 32
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

    // --- Address Map (Byte Addresses) ---
    localparam ADDR_CTRL      = 32'h000;
    localparam ADDR_STATUS    = 32'h008; // Moved to 0x8 to keep 64-bit alignment
    localparam ADDR_IN_START  = 32'h010; // 0x10 to 0x20F (64 words)
    localparam ADDR_OUT_START = 32'h210; // 0x210 to 0x40F (64 words)

    // Internal logic for DCT
    logic [DATA_WIDTH-1:0] in_block  [0:63];
    logic [DATA_WIDTH-1:0] out_block [0:63];
    logic                  dct_start;
    logic                  dct_done;
    logic                  dct_busy;

    // AXI Internal State
    logic [ADDR_WIDTH-1:0] awaddr_reg;
    logic [7:0]            awburst_cnt;
    logic                  aw_active;
    logic [3:0]            awid_reg;

    logic [ADDR_WIDTH-1:0] araddr_reg;
    logic [7:0]            arburst_cnt;
    logic                  ar_active;
    logic [3:0]            arid_reg;

    // --- Write Channel Control ---
    assign awready = !aw_active;
    assign wready  = aw_active;

    always_ff @(posedge clk or negedge reset_n) begin
        if (!reset_n) begin
            aw_active     <= 1'b0;
            awaddr_reg    <= '0;
            awid_reg      <= '0;
            awburst_cnt   <= '0;
            dct_start     <= 1'b0;
            // Clear input buffer on reset if needed
            for (int i=0; i<64; i++) in_block[i] <= '0;
        end else begin
            dct_start <= 1'b0; // Pulse by default

            // Accept Write Address
            if (awvalid && awready) begin
                aw_active   <= 1'b1;
                awaddr_reg  <= awaddr;
                awid_reg    <= awid;
                awburst_cnt <= awlen;
            end 
            
            // Accept Write Data
            if (wvalid && wready) begin
                // Address Decoding
                if (awaddr_reg == ADDR_CTRL) begin
                    if (wdata[0]) dct_start <= 1'b1;
                end 
                else if (awaddr_reg >= ADDR_IN_START && awaddr_reg < ADDR_OUT_START) begin
                    in_block[(awaddr_reg - ADDR_IN_START) >> 3] <= wdata;
                end

                // Burst Handling
                if (awburst_cnt == 0) begin
                    aw_active <= 1'b0;
                end else begin
                    awaddr_reg  <= awaddr_reg + (1 << awsize);
                    awburst_cnt <= awburst_cnt - 1;
                end
            end
        end
    end

    // --- Write Response ---
    always_ff @(posedge clk or negedge reset_n) begin
        if (!reset_n) begin
            bvalid <= 1'b0;
            bid    <= '0;
            bresp  <= 2'b00;
        end else begin
            if (wvalid && wready && wlast) begin
                bvalid <= 1'b1;
                bid    <= awid_reg;
            end else if (bready) begin
                bvalid <= 1'b0;
            end
        end
    end

    // --- Read Channel Control ---
    assign arready = !ar_active;

    always_ff @(posedge clk or negedge reset_n) begin
        if (!reset_n) begin
            ar_active   <= 1'b0;
            araddr_reg  <= '0;
            arid_reg    <= '0;
            arburst_cnt <= '0;
            rvalid      <= 1'b0;
            rlast       <= 1'b0;
        end else begin
            if (arvalid && arready) begin
                ar_active   <= 1'b1;
                araddr_reg  <= araddr;
                arid_reg    <= arid;
                arburst_cnt <= arlen;
            end

            if (ar_active && (!rvalid || rready)) begin
                rvalid <= 1'b1;
                rid    <= arid_reg;
                rlast  <= (arburst_cnt == 0);
                
                // Address Decoding for Reads
                if (araddr_reg == ADDR_STATUS) begin
                    if( dct_done )
                        rdata <= {64{1'b1}};
                    else
                        rdata <= {64{1'b0}};
                end 
                else if (araddr_reg >= ADDR_OUT_START && araddr_reg < (ADDR_OUT_START + 512)) begin
                    rdata <= out_block[(araddr_reg - ADDR_OUT_START) >> 3];
                end 
                else begin
                    rdata <= '0;
                end

                if (arburst_cnt == 0) begin
                    ar_active <= 1'b0;
                end else begin
                    araddr_reg  <= araddr_reg + (1 << arsize);
                    arburst_cnt <= arburst_cnt - 1;
                end
            end else if (rvalid && rready) begin
                rvalid <= 1'b0;
                rlast  <= 1'b0;
            end
        end
    end

    // --- DCT State Machine ---
    always_ff @(posedge clk or negedge reset_n) begin
        if (!reset_n) begin
            dct_busy <= 1'b0;
        end else begin
            if (dct_start) dct_busy <= 1'b1;
            else if (dct_done) dct_busy <= 1'b0;
        end
    end

    // --- DCT Instance ---
    dct_compute u_dct_compute (
        .clk      (clk),
        .reset_n  (reset_n),
        .start    (dct_start),
        .in_block (in_block),
        .out_block(out_block),
        .done     (dct_done)
    );

endmodule