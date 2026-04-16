// =============================================================================
// dct_compute.sv
//
// Drop-in synthesizable replacement for the behavioural dct_compute module.
// IDENTICAL port list:
//   clk, reset_n, start, in_block[63:0][0:63], out_block[63:0][0:63], done
//
// Strategy
// --------
//  1. Convert IEEE-754 doubles (in_block) → signed fixed-point Q8.16 on LOAD.
//     Full IEEE-754 decode is unneeded here because the original code just calls
//     $bitstoreal; instead we instantiate a minimal exponent/mantissa unpacker.
//     If your toolchain provides a hard-macro FP unit, swap that in at the same
//     boundary.
//
//  2. Perform a separable 2-D DCT as two passes of 1-D DCT, sharing one engine:
//       Pass A: apply engine to every row  → store into transposed buffer
//       Pass B: apply engine to every col  → store into output buffer
//
//  3. Each 1-D DCT is an 8-point type-II DCT implemented as a fully-unrolled
//     MAC array: 8 output frequencies × 8 input samples = 64 multiplies per row.
//     Cosine coefficients are Q1.14 signed constants (ROM, synthesises to LUTs).
//
//  4. The ×0.25 final scaling from the original CONVERT_BACK state is absorbed
//     as a 2-bit arithmetic right-shift, so no extra multiplier is needed.
//
//  5. Output values are converted back to IEEE-754 doubles.
//
// Latency: 1 (LOAD) + 8 (ROW_DCT, 1 row/cycle) + 8 (COL_DCT, 1 col/cycle)
//          + 1 (STORE) = 18 clock cycles per 8×8 block.
//
// Fixed-point format
// ------------------
//  Input / intermediate: signed Q8.16  (32-bit, 8 integer + 16 fractional)
//  Cosine ROM          : signed Q1.14  (16-bit)
//  MAC accumulator     : 32 + 16 + 3  = 51-bit signed (8 products summed)
//  After C(u) scale    : 51 + 16      = 67-bit, truncated back to Q8.16
//  After ×0.25 shift   : arithmetic >> 2, stays Q8.16
// =============================================================================

module dct_compute (
    input  logic        clk,
    input  logic        reset_n,
    input  logic        start,
    input  logic [63:0] in_block  [0:63],
    output logic [63:0] out_block [0:63],
    output logic        done
);

    
    // =========================================================================
    // 1.  Cosine ROM – using functions instead of parameters
    // =========================================================================

    // Function to get cosine values
    function automatic logic signed [15:0] get_cos_value;
        input int n;  // spatial index 0-7
        input int k;  // frequency index 0-7
        begin
            case ({n, k})
                // n=0
                0: get_cos_value = 16384;   // k=0
                1: get_cos_value = 16069;   // k=1
                2: get_cos_value = 15137;   // k=2
                3: get_cos_value = 13623;   // k=3
                4: get_cos_value = 11585;   // k=4
                5: get_cos_value = 9102;    // k=5
                6: get_cos_value = 6270;    // k=6
                7: get_cos_value = 3196;    // k=7
                // n=1
                8:  get_cos_value = 16384;
                9:  get_cos_value = 13623;
                10: get_cos_value = 6270;
                11: get_cos_value = -3196;
                12: get_cos_value = -11585;
                13: get_cos_value = -16069;
                14: get_cos_value = -15137;
                15: get_cos_value = -9102;
                // n=2
                16: get_cos_value = 16384;
                17: get_cos_value = 9102;
                18: get_cos_value = -6270;
                19: get_cos_value = -16069;
                20: get_cos_value = -11585;
                21: get_cos_value = 3196;
                22: get_cos_value = 15137;
                23: get_cos_value = 13623;
                // n=3
                24: get_cos_value = 16384;
                25: get_cos_value = 3196;
                26: get_cos_value = -15137;
                27: get_cos_value = -13623;
                28: get_cos_value = 11585;
                29: get_cos_value = 16069;
                30: get_cos_value = -6270;
                31: get_cos_value = -9102;
                // n=4
                32: get_cos_value = 16384;
                33: get_cos_value = -3196;
                34: get_cos_value = -15137;
                35: get_cos_value = 13623;
                36: get_cos_value = 11585;
                37: get_cos_value = -16069;
                38: get_cos_value = -6270;
                39: get_cos_value = 9102;
                // n=5
                40: get_cos_value = 16384;
                41: get_cos_value = -9102;
                42: get_cos_value = -6270;
                43: get_cos_value = 16069;
                44: get_cos_value = -11585;
                45: get_cos_value = -3196;
                46: get_cos_value = 15137;
                47: get_cos_value = -13623;
                // n=6
                48: get_cos_value = 16384;
                49: get_cos_value = -13623;
                50: get_cos_value = 6270;
                51: get_cos_value = 3196;
                52: get_cos_value = -11585;
                53: get_cos_value = 16069;
                54: get_cos_value = -15137;
                55: get_cos_value = 9102;
                // n=7
                56: get_cos_value = 16384;
                57: get_cos_value = -16069;
                58: get_cos_value = 15137;
                59: get_cos_value = -3623;
                60: get_cos_value = 11585;
                61: get_cos_value = -9102;
                62: get_cos_value = 6270;
                63: get_cos_value = -3196;
                default: get_cos_value = 0;
            endcase
        end
    endfunction
    
    // Function to get C factor
    function automatic logic signed [15:0] get_c_factor;
        input int k;
        begin
            case (k)
                0: get_c_factor = 16'sh2D41;
                1,2,3,4,5,6,7: get_c_factor = 16'sh4000;
                default: get_c_factor = 16'sh4000;
            endcase
        end
    endfunction
     
    // =========================================================================
    // 2.  State machine
    // =========================================================================

    typedef enum logic [2:0] {
        IDLE     = 3'd0,
        LOAD     = 3'd1,
        ROW_DCT  = 3'd2,
        COL_DCT  = 3'd3,
        STORE    = 3'd4,
        DONE_ST  = 3'd5
    } state_t;

    state_t state;
    logic [2:0] idx;  // 0..7, counts rows then columns
    logic [3:0] done_cnt;  // cuenta hasta 10

    // =========================================================================
    // 3.  Fixed-point data storage
    //     fp_in  [row][col] : loaded from in_block, Q8.16
    //     fp_mid [row][col] : after row DCT (stored transposed for col pass)
    //     fp_out [row][col] : after col DCT (before output conversion)
    // =========================================================================

    logic signed [31:0] fp_in  [0:7][0:7];
    logic signed [31:0] fp_mid [0:7][0:7];  // transposed: fp_mid[col][row]
    logic signed [31:0] fp_out [0:7][0:7];

    // =========================================================================
    // 4.  IEEE-754 double → Q8.16 fixed-point conversion
    //     Layout: [63] sign | [62:52] biased exponent | [51:0] mantissa
    //     We reconstruct: value ≈ (-1)^s * 2^(exp-1023) * 1.mantissa
    //     Scaled to Q8.16 = multiply by 2^16, so shift mantissa by (exp-1023+16-52).
    //     Saturates on overflow; sets zero on denormals/NaN/Inf for safety.
    // =========================================================================

    function automatic logic signed [31:0] double_to_fixed;
        input logic [63:0] d;
        logic        sign;
        logic [10:0] exp_biased;
        logic [51:0] mantissa;
        logic [63:0] full_mant;  // 1.mantissa as unsigned 53-bit value
        int          shift;
        logic signed [63:0] shifted;
        logic signed [31:0] result;
        begin
            sign        = d[63];
            exp_biased  = d[62:52];
            mantissa    = d[51:0];

            // Zero / denormal / NaN / Inf guard
            if (exp_biased == 11'd0 || exp_biased == 11'h7FF) begin
                double_to_fixed = 32'sd0;
            end else begin
                // Reconstruct 1.mantissa in Q0.52 (53 integer bits, implicit leading 1)
                full_mant = {12'b0, 1'b1, mantissa};  // bits [52:0] = 1.mantissa * 2^52

                // Target: Q8.16.  We need to shift full_mant by:
                //   (exp_biased - 1023) + 16 - 52  =  exp_biased - 1059
                shift = int'(exp_biased) - 1059;

                if (shift >= 24) begin
                    // Overflow → saturate
                    result = sign ? 32'sh80000000 : 32'sh7FFFFFFF;
                end else if (shift > 0) begin
                    shifted = 64'(full_mant) << shift;
                    result  = shifted[31:0];
                end else if (shift > -52) begin
                    shifted = 64'(full_mant) >> (-shift);
                    result  = shifted[31:0];
                end else begin
                    result = 32'sd0;  // value rounds to zero
                end

                double_to_fixed = sign ? -result : result;
            end
        end
    endfunction

    // =========================================================================
    // 5.  Q8.16 fixed-point → IEEE-754 double conversion
    //     We reconstruct a normalised double from the 32-bit signed value.
    // =========================================================================

    function automatic logic [63:0] fixed_to_double;
        input logic signed [31:0] fx;
        logic        sign;
        logic [31:0] abs_val;
        logic [5:0]  leading_zeros;
        logic [10:0] exponent;
        logic [51:0] mantissa_bits;
        logic [31:0] normalised;
        begin
            if (fx == 32'sd0) begin
                fixed_to_double = 64'd0;
            end else begin
                sign    = fx[31];
                abs_val = sign ? -fx : fx;

                // Count leading zeros to find the position of the implicit leading 1
                // For a 32-bit value, leading_zeros ∈ [0,31]
                leading_zeros = 6'd0;
                for (int b = 31; b >= 0; b--) begin
                    if (abs_val[b]) break;
                    leading_zeros++;
                end

                // Normalise: shift abs_val so the leading 1 is at bit 31
                normalised = abs_val << leading_zeros;

                // Exponent: the implicit 1 is at position (31 - leading_zeros)
                // in our Q8.16 representation, the binary point is at bit 16.
                // So the true value exponent (base-2) relative to bit 31 is:
                //   (31 - leading_zeros) - 16  = 15 - leading_zeros
                // Biased: + 1023
                exponent = 11'd1023 + 11'(15 - int'(leading_zeros));

                // Take the 52 bits below the implicit 1 (bits [30:0] of normalised,
                // padded to 52 bits)
                mantissa_bits = {normalised[30:0], 21'b0};

                fixed_to_double = {sign, exponent, mantissa_bits};
            end
        end
    endfunction

    // =========================================================================
    // 6.  1-D DCT engine (purely combinational – called each cycle for one
    //     row or column)
    //
    //     Computes:  out[k] = C(k) * Σ_{n=0}^{7} in[n] * cos_table[n][k]
    //     All arithmetic in Q8.16 × Q1.14 → Q9.30, accumulated over 8 terms,
    //     then C(k) applied and result truncated back to Q8.16.
    //     The ×0.25 final scale is applied here as >> 2.
    // =========================================================================

    
     function automatic logic signed [31:0] dct1d_output;
        input logic signed [31:0] vec [0:7];
        input int                 freq_k;
        logic signed [66:0] acc;
        logic signed [66:0] product;
        logic signed [66:0] scaled;
        begin
            acc = '0;
            for (int n = 0; n < 8; n++) begin
                // Use function call instead of array lookup
                product = 67'(vec[n]) * 67'(get_cos_value(n, freq_k));
                acc    += product;
            end
            scaled = (acc >>> 14) * 67'(get_c_factor(freq_k));
            scaled = scaled >>> 14;
            scaled = scaled >>> 2;
            dct1d_output = scaled[31:0];
        end
    endfunction

    // =========================================================================
    // 7.  Sequential state machine
    // =========================================================================

    always_ff @(posedge clk or negedge reset_n) begin
        if (!reset_n) begin
            state <= IDLE;
            done  <= 1'b0;
            idx   <= 3'd0;
            done_cnt <= 4'd0;
            for (int i = 0; i < 64; i++) out_block[i] <= 64'd0;
        end else begin
            case (state)

                // ----------------------------------------------------------
                IDLE: begin
                    done <= 1'b0;
                    if (start) begin
                        idx   <= 3'd0;
                        state <= LOAD;
                    end
                end

                // ----------------------------------------------------------
                // LOAD: convert all 64 doubles → fixed-point in one cycle.
                // This is a wide combinational fan-out; if timing is tight,
                // split into 8 sub-cycles (one row per cycle) like ROW_DCT.
                // ----------------------------------------------------------
                LOAD: begin
                    for (int r = 0; r < 8; r++)
                        for (int c = 0; c < 8; c++)
                            fp_in[r][c] <= double_to_fixed(in_block[r*8 + c]);
                    idx   <= 3'd0;
                    state <= ROW_DCT;
                end

                // ----------------------------------------------------------
                // ROW_DCT: one row per cycle.
                // Results are written transposed into fp_mid so that
                // columns of the original become rows for the column pass.
                // ----------------------------------------------------------
                ROW_DCT: begin
                    for (int k = 0; k < 8; k++) begin
                        // Build input vector for this row
                        automatic logic signed [31:0] row_vec [0:7];
                        for (int n = 0; n < 8; n++)
                            row_vec[n] = fp_in[idx][n];
                        // Store transposed: fp_mid[col][row]
                        fp_mid[k][idx] <= dct1d_output(row_vec, k);
                    end

                    if (idx == 3'd7) begin
                        idx   <= 3'd0;
                        state <= COL_DCT;
                    end else begin
                        idx <= idx + 1'd1;
                    end
                end

                // ----------------------------------------------------------
                // COL_DCT: one column per cycle (each column is now a row in
                // fp_mid due to the transpose above).
                // ----------------------------------------------------------
                COL_DCT: begin
                    for (int k = 0; k < 8; k++) begin
                        automatic logic signed [31:0] col_vec [0:7];
                        for (int n = 0; n < 8; n++)
                            col_vec[n] = fp_mid[idx][n];
                        fp_out[k][idx] <= dct1d_output(col_vec, k);
                    end

                    if (idx == 3'd7) begin
                        idx   <= 3'd0;
                        state <= STORE;
                    end else begin
                        idx <= idx + 1'd1;
                    end
                end

                // ----------------------------------------------------------
                // STORE: convert fixed-point results back to IEEE-754 doubles.
                // ----------------------------------------------------------
                STORE: begin
                    for (int r = 0; r < 8; r++)
                        for (int c = 0; c < 8; c++)
                            out_block[r*8 + c] <= fixed_to_double(fp_out[r][c]);
                    state <= DONE_ST;
                end

                // ----------------------------------------------------------
                DONE_ST: begin
                    done <= 1'b1;

                    if (done_cnt == 4'd9) begin
                        done_cnt <= 4'd0;
                        state    <= IDLE;
                    end else begin
                        done_cnt <= done_cnt + 1'd1;
                        state <= DONE_ST;
                    end
                end

                default: state <= IDLE;

            endcase
        end
    end

endmodule
