// Code 
#include <stdio.h>

// Precomputed DCT matrix: cos((2x+1)u*pi / 16.0)
// Rows = x, Columns = u
static const double DCT_LUT[8][8] = {
    {1.0000, 1.0000, 1.0000, 1.0000, 1.0000, 1.0000, 1.0000, 1.0000},
    {0.9808, 0.8315, 0.5556, 0.1951, -0.1951, -0.5556, -0.8315, -0.9808},
    {0.9239, 0.3827, -0.3827, -0.9239, -0.9239, -0.3827, 0.3827, 0.9239},
    {0.8315, -0.1951, -0.9808, -0.5556, 0.5556, 0.9808, 0.1951, -0.8315},
    {0.7071, -0.7071, -0.7071, 0.7071, 0.7071, -0.7071, -0.7071, 0.7071},
    {0.5556, -0.9808, 0.1951, 0.8315, -0.8315, -0.1951, 0.9808, -0.5556},
    {0.3827, -0.9239, 0.9239, -0.3827, -0.3827, 0.9239, -0.9239, 0.3827},
    {0.1951, -0.5556, 0.8315, -0.9808, 0.9808, -0.8315, 0.5556, -0.1951}
};

extern "C" void dct(double in_block[8][8], double out_block[8][8]) {
    int u, v, x, y;
    double cu, cv, sum;

    for (u = 0; u < 8; u++) {
        for (v = 0; v < 8; v++) {
            sum = 0.0;

            for (x = 0; x < 8; x++) {
                for (y = 0; y < 8; y++) {
                    // Use the LUT instead of calling cos()
                    sum += in_block[x][y] * DCT_LUT[u][x] * DCT_LUT[v][y];
                }
            }

            cu = (u == 0) ? 0.70710678 : 1.0;  // 1.0 / sqrt(2.0)
            cv = (v == 0) ? 0.70710678 : 1.0;

            out_block[u][v] = 0.25 * cu * cv * sum;
        }
    }
}
/*
#include <math.h> 
#include <stdio.h> 

#define PI 3.14159265358979323846 

extern "C" void dct(double in_block[8][8], double out_block[8][8]) { 

    int u, v, x, y; 
    double cu, cv, sum; 

    // Loop over each element in the output block 
    for (u = 0; u < 8; u++) { 
        for (v = 0; v < 8; v++) { 
            sum = 0.0; 
            // Compute the DCT coefficient for (u, v) 
            for (x = 0; x < 8; x++) { 
                for (y = 0; y < 8; y++) { 
                    sum += in_block[x][y] *  
                           cos((2 * x + 1) * u * PI / 16.0) *  
                           cos((2 * y + 1) * v * PI / 16.0); 
                } 
            } 

            // Normalization factors 
            cu = (u == 0) ? 1.0 / sqrt(2.0) : 1.0; 
            cv = (v == 0) ? 1.0 / sqrt(2.0) : 1.0; 

            // Apply normalization and store the result 
            out_block[u][v] = 0.25 * cu * cv * sum; 
            fprintf(stdout, "###DCT### IN_BLOCK[%d][%d]=%f - OUT_BLOCK[%d][%d]=%f \n", u, v, in_block[u][v], u, v, out_block[u][v] );
        } 
    } 
} */