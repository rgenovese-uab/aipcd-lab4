// Code 
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
} 