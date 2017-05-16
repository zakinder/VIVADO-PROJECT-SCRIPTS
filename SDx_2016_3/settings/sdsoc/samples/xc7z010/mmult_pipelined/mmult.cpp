/*
(c) Copyright 2013 - 2016 Xilinx, Inc. All rights reserved. 

This file contains confidential and proprietary information of Xilinx, Inc. and
is protected under U.S. and international copyright and other intellectual
property laws.

DISCLAIMER 
This disclaimer is not a license and does not grant any rights to the materials
distributed herewith. Except as otherwise provided in a valid license issued to
you by Xilinx, and to the maximum extent permitted by applicable law: (1) THESE
MATERIALS ARE MADE AVAILABLE "AS IS" AND WITH ALL FAULTS, AND XILINX HEREBY
DISCLAIMS ALL WARRANTIES AND CONDITIONS, EXPRESS, IMPLIED, OR STATUTORY,
INCLUDING BUT NOT LIMITED TO WARRANTIES OF MERCHANTABILITY, NON-INFRINGEMENT, OR
FITNESS FOR ANY PARTICULAR PURPOSE; and (2) Xilinx shall not be liable (whether
in contract or tort, including negligence, or under any other theory of
liability) for any loss or damage of any kind or nature related to, arising
under or in connection with these materials, including for any direct, or any
indirect, special, incidental, or consequential loss or damage (including loss
of data, profits, goodwill, or any type of loss or damage suffered as a result
of any action brought by a third party) even if such damage or loss was
reasonably foreseeable or Xilinx had been advised of the possibility of the
same.

CRITICAL APPLICATIONS
Xilinx products are not designed or intended to be fail-safe, or for use in any
application requiring fail-safe performance, such as life-support or safety
devices or systems, Class III medical devices, nuclear facilities, applications
related to the deployment of airbags, or any other applications that could lead
to death, personal injury, or severe property or environmental damage
(individually and collectively, "Critical Applications"). Customer assumes the
sole risk and liability of any use of Xilinx products in Critical Applications,
subject only to applicable laws and regulations governing limitations on product
liability.

THIS COPYRIGHT NOTICE AND DISCLAIMER MUST BE RETAINED AS PART OF THIS FILE AT
ALL TIMES. 
*/

#include <iostream>
#include <stdlib.h>
#include <stdint.h>

#include "sds_lib.h"
#include "mmult_accel.h"

#define NUM_MAT 4
#define NUM_TESTS 256

#define PIPELINE_DEPTH_MIN	1
#define PIPELINE_DEPTH_MAX	3
#define PIPELINE_DEPTH_DEFAULT	2

class perf_counter
{
public:
  uint64_t tot, cnt, calls;
  perf_counter() : tot(0), cnt(0), calls(0) {};
  inline void reset() { tot = cnt = calls = 0; }
  inline void start() { cnt = sds_clock_counter(); calls++; };
  inline void stop() { tot += (sds_clock_counter() - cnt); };
  inline uint64_t avg_cpu_cycles() { return (tot / calls); };
};

static void init_arrays(float *A[NUM_MAT],  
                        float *B[NUM_MAT], 
                        float *C_sw[NUM_MAT], 
                        float *C[NUM_MAT])
{
     for (int m = 0; m < NUM_MAT; m++) {
          for (int i = 0; i < N; i++) {
               for (int j = 0; j < N; j++) {
                    A[m][i * N + j] = 1+i*N+j;
                    B[m][i * N + j] = rand() % (N * N);
                    C_sw[m][i * N + j] = 0.0;
                    C[m][i * N + j] = 0.0;
               }
          }
     }
}

void mmult_golden(float *A,  float *B, float *C)
{
     for (int row = 0; row < N; row++) {
          for (int col = 0; col < N; col++) {
               float result = 0.0;
               for (int k = 0; k < N; k++) {
                    result += A[row*N+k] * B[k*N+col];
               }
               C[row*N+col] = result;
          }
     }
}

static int result_check(float *C[NUM_MAT], float *C_sw[NUM_MAT])
{
     for (int m = 0; m < NUM_MAT; m++) {
          for (int i = 0; i < N * N; i++) {
               if (C_sw[m][i] != C[m][i]) {
                    std::cout << "Mismatch: data index=" << i << "d=" << C_sw[m][i] 
                              << ", dout=" << C[m][i] << std::endl;
                    return 1;
               }
          }
     }
     return 0;
}

int mmult_test(float *A[NUM_MAT],  
               float *B[NUM_MAT], 
               float *C_sw[NUM_MAT], 
               float *C[NUM_MAT],
               int pipeline_depth)
{
     std::cout << "Running " << NUM_TESTS << " iterations of " << N << "x" << N 
               << " task pipelined floating point mmult..." << std::endl;

     perf_counter hw_ctr, sw_ctr;

     init_arrays(A, B, C_sw, C);

     sw_ctr.start();

     for (int i = 0; i < NUM_TESTS; i++) {
       mmult_golden(A[i%NUM_MAT], B[i%NUM_MAT], C_sw[i%NUM_MAT]);
     }
     
     sw_ctr.stop();

     hw_ctr.start();

     for (int i = 0; i < pipeline_depth; i++) {
#pragma SDS async(1)
          mmult_accel(A[i%NUM_MAT], B[i%NUM_MAT], C[i%NUM_MAT]);
     }

     for (int i = pipeline_depth; i < NUM_TESTS-pipeline_depth; i++) {
#pragma SDS wait(1)
#pragma SDS async(1)
          mmult_accel(A[i%NUM_MAT], B[i%NUM_MAT], C[i%NUM_MAT]);
     }
     for (int i = 0; i < pipeline_depth; i++) {
#pragma SDS wait(1)
     }

     hw_ctr.stop();

     uint64_t sw_cycles = sw_ctr.avg_cpu_cycles()/NUM_TESTS;
     uint64_t hw_cycles = hw_ctr.avg_cpu_cycles()/NUM_TESTS;
     double speedup = (double) sw_cycles / (double) hw_cycles;

     std::cout << "Average number of CPU cycles running mmult in software: "
               << sw_cycles << std::endl;
     std::cout << "Average number of CPU cycles running mmult in hardware: "
               << hw_cycles << std::endl;
     std::cout << "Speed up: " << speedup << std::endl;

     int result = 0;
     for (int i = 0; !result && i < NUM_MAT; i++)
          result = result_check(C, C_sw);
     return result;
}

/**
 * Design principles to achieve performance
 *
 * 1. sds_alloc to guarantee physically contiguous buffer allocation
 *    that enables the most efficient DMA configuration (axidma_simple)
 */
int main(int argc, char* argv[])
{
     int pipeline_depth = PIPELINE_DEPTH_DEFAULT;
     float *A[NUM_MAT], *B[NUM_MAT], *C_sw[NUM_MAT], *C[NUM_MAT];

     // use pipeline depth from command argument, if passed in
     if (argc == 2) {
          pipeline_depth = atoi(argv[1]);
          if (pipeline_depth > PIPELINE_DEPTH_MAX || pipeline_depth < PIPELINE_DEPTH_MIN) {
               std::cout << "Please use pipeline depth from " << PIPELINE_DEPTH_MIN
                         << " to " << PIPELINE_DEPTH_MAX << std::endl;
               return 1;
          }
     }
     for (int m = 0; m < NUM_MAT; m++) {
          A[m] = (float *)sds_alloc(N * N * sizeof(float));
          B[m] = (float *)sds_alloc(N * N * sizeof(float));
          C[m] = (float *)sds_alloc(N * N * sizeof(float));
          C_sw[m] = (float *)sds_alloc(N * N * sizeof(float));
     
          if (!A[m] || !B[m] || !C[m] || !C_sw[m]) {
               if (A[m]) sds_free(A[m]);
               if (B[m]) sds_free(B[m]);
               if (C[m]) sds_free(C[m]);
               if (C_sw[m]) sds_free(C_sw[m]);
               return 2;
          }
     }
     int test_failed = mmult_test(A, B, C_sw, C, pipeline_depth);
     
     std::cout << "TEST " << (test_failed ? "FAILED" : "PASSED") << std::endl;

     for (int m = 0; m < NUM_MAT; m++) {
          sds_free(A[m]);
          sds_free(B[m]);
          sds_free(C[m]);
          sds_free(C_sw[m]);
     }     

     return (test_failed ? -1 : 0);
}

// XSIP watermark, do not delete 67d7842dbbe25473c3c32b93c0da8047785f30d78e8a024de1b57352245f9689
