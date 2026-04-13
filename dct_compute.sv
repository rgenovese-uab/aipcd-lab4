// dct_compute.sv - DCT computation block for 8x8 matrix
module dct_compute (
    input  logic        clk,
    input  logic        reset_n,
    input  logic        start,           // Start computation
    input  logic [63:0] in_block [0:63], // Input 64 values (double precision)
    output logic [63:0] out_block [0:63],// Output 64 values (double precision)
    output logic        done             // Computation complete
);

    // DCT coefficients for 8x8 (scaled)
    // Using standard JPEG DCT coefficients
    
    // Local variables for computation
    logic [7:0] i, j, u, v;
    logic [7:0] compute_idx;
    logic [2:0] state;
    logic [63:0] temp [0:63];  // Intermediate storage
    logic [63:0] alpha_u, alpha_v;
    real sum, cu, cv;
    
    // Convert logic[63:0] to real for computation
    real input_real [0:7][0:7];
    real output_real [0:7][0:7];
    real temp_real [0:7][0:7];
    
    // DCT coefficient constants (C(u) = 1/sqrt(2) for u=0, else 1)
    // Actually implementing: F(u,v) = C(u)*C(v) * sum_{x=0..7} sum_{y=0..7} f(x,y) * cos((2x+1)*u*pi/16) * cos((2y+1)*v*pi/16)
    
    // Pre-computed cosine values for 8x8 DCT
    real cos_table [0:7][0:7];
    
    // State machine states
    localparam IDLE      = 3'd0;
    localparam CONVERT   = 3'd1;
    localparam DCT_ROW   = 3'd2;
    localparam DCT_COL   = 3'd3;
    localparam CONVERT_BACK = 3'd4;
    localparam DONE_ST   = 3'd5;
    
    // Initialize cosine table
    initial begin
        for (int x = 0; x < 8; x++) begin
            for (int u = 0; u < 8; u++) begin
                cos_table[x][u] = $cos( (2.0 * x + 1.0) * u * 3.141592653589793 / 16.0 );
            end
        end
    end
    
    // Compute C factor: C(0) = 1/sqrt(2), C(k) = 1 for k>0
    function real c_factor;
        input int k;
        if (k == 0)
            c_factor = 0.7071067811865476; // 1/sqrt(2)
        else
            c_factor = 1.0;
    endfunction
    
    // Convert logic[63:0] to real
    function real bits_to_real;
        input logic [63:0] bits;
        bits_to_real = $bitstoreal(bits);
    endfunction
    
    // Convert real to logic[63:0]
    function logic [63:0] real_to_bits;
        input real r;
        real_to_bits = $realtobits(r);
    endfunction
    
    // Row DCT - compute 1D DCT on each row
    task compute_row_dct;
        input int row;
        output real row_out[0:7];
        real temp_row[0:7];
        begin
            for (int v = 0; v < 8; v++) begin
                automatic real sum = 0.0;
                for (int x = 0; x < 8; x++) begin
                    sum += temp_real[row][x] * cos_table[x][v];
                end
                temp_row[v] = c_factor(v) * sum;
            end
            for (int v = 0; v < 8; v++) begin
                row_out[v] = temp_row[v];
            end
        end
    endtask
    
    // Column DCT - compute 1D DCT on each column
    task compute_col_dct;
        input int col;
        output real col_out[0:7];
        real temp_col[0:7];
        begin
            for (int u = 0; u < 8; u++) begin
                automatic real sum = 0.0;
                for (int y = 0; y < 8; y++) begin
                    sum += temp_real[y][col] * cos_table[y][u];
                end
                temp_col[u] = c_factor(u) * sum;
            end
            for (int u = 0; u < 8; u++) begin
                col_out[u] = temp_col[u];
            end
        end
    endtask
    
    // Sequential logic for DCT computation
    always_ff @(posedge clk or negedge reset_n) begin
        if (!reset_n) begin
            state <= IDLE;
            done <= 1'b0;
            compute_idx <= 8'd0;
            for (int idx = 0; idx < 64; idx++) begin
                out_block[idx] <= 64'd0;
                temp[idx] <= 64'd0;
            end
            for (int r = 0; r < 8; r++) begin
                for (int c = 0; c < 8; c++) begin
                    input_real[r][c] = 0.0;
                    output_real[r][c] = 0.0;
                    temp_real[r][c] = 0.0;
                end
            end
        end else begin
            case (state)
                IDLE: begin
                    done <= 1'b0;
                    if (start) begin
                        state <= CONVERT;
                        compute_idx <= 8'd0;
                    end
                end
                
                CONVERT: begin
                    // Convert input bits to real values
                    for (int idx = 0; idx < 64; idx++) begin
                        automatic int row = idx / 8;
                        automatic int col = idx % 8;
                        input_real[row][col] = bits_to_real(in_block[idx]);
                        temp_real[row][col] = input_real[row][col];
                    end
                    state <= DCT_ROW;
                    compute_idx <= 8'd0;
                end
                
                DCT_ROW: begin
                    // Compute 1D DCT on each row
                    if (compute_idx < 8) begin
                        real row_result[0:7];
                        compute_row_dct(compute_idx, row_result);
                        for (int c = 0; c < 8; c++) begin
                            temp_real[compute_idx][c] = row_result[c];
                        end
                        compute_idx <= compute_idx + 1;
                    end else begin
                        state <= DCT_COL;
                        compute_idx <= 8'd0;
                    end
                end
                
                DCT_COL: begin
                    // Compute 1D DCT on each column
                    if (compute_idx < 8) begin
                        real col_result[0:7];
                        compute_col_dct(compute_idx, col_result);
                        for (int r = 0; r < 8; r++) begin
                            temp_real[r][compute_idx] = col_result[r];
                        end
                        compute_idx <= compute_idx + 1;
                    end else begin
                        state <= CONVERT_BACK;
                        compute_idx <= 8'd0;
                    end
                end
                
                CONVERT_BACK: begin
                    // Scale and convert back to bits
                    for (int idx = 0; idx < 64; idx++) begin
                        automatic int row = idx / 8;
                        automatic int col = idx % 8;
                        // Apply final scaling: result = (1/4) * current
                        output_real[row][col] = temp_real[row][col] * 0.25;
                        out_block[idx] <= real_to_bits(output_real[row][col]);
                    end
                    state <= DONE_ST;
                end
                
                DONE_ST: begin
                    done <= 1'b1;
                    state <= IDLE;
                end
            endcase
        end
    end

endmodule