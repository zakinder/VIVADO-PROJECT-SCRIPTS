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

#include <stdio.h>
#include <string.h>
#include <stdlib.h>
#include <ctype.h>
#include <math.h>
#include "manr.h"

#include "math.h"
#include "malloc.h"
#include "assert.h"
#include <unistd.h>
#include <errno.h>
#include <signal.h>
#include <fcntl.h>
#include <termios.h>
#include <sys/types.h>
#include <sys/mman.h>

#include "platform/frame_size.h"
#include "platform/rgb_utils.h"
#include "platform/video_utils.h"
#include "platform/yuv_utils.h"
#include "sds_lib.h"
#define TIME_STAMP_INIT  unsigned long clock_start, clock_end;  clock_start = sds_clock_counter();  
#define TIME_STAMP  { clock_end = sds_clock_counter(); printf("elapsed time %lu \n", clock_end-clock_start); clock_start = sds_clock_counter();  }

#define MAX_FRAMES 120
unsigned short *in_frames[MAX_FRAMES];
unsigned short *out_frames[MAX_FRAMES];
unsigned short *yc_in_prev;
unsigned short *yc_out_tmp;



int print_help(char *exec_name)
{
  printf("\nUsage: %s in_file #frames  nr_strength out_file\n\n", exec_name);
  printf("       in_file        :  Path/name of the input file - must be .yuv 1080 YUV422 format.\n");
  printf("       frames         :  Number of frames in input file.\n");
  printf("       nr_strength    :  Noise reduction strength range 0-4:\n");
  printf("                            0: None\n");
  printf("                            1: Weak\n");
  printf("                            2: Medium\n");
  printf("                            3: Strong\n");
  printf("                            4: Aggressive\n");
  printf("       out_file        :  Path/name of the output file - written as yuv.\n");
  return(1);
}

int free_frames(int frames)
{
  int   frame ;
  printf("freeing all malloced memory\n"); 
  for (frame = 0; frame < frames; frame++) {
    if (in_frames[frame] != NULL) {
      free(in_frames[frame]) ;
    }
    if (out_frames[frame] != NULL) {
      free(out_frames[frame]) ;
    }
  }
  if (yc_out_tmp != NULL) {
    free(yc_out_tmp);
  }
  if (yc_in_prev != NULL) {
    free(yc_in_prev);
  }
  return 1;
}

int write_frames(char* out_filename, int frames, int rows, int cols, int chroma)
{
  FILE *out_fid = NULL;
  unsigned short *yc_out;
  unsigned short yc_out_tmp1, yc_out_tmp2;
  struct video_struct video_out;  
  struct yuv8_video_struct yuv8_video_out ;
  int frame, row, col;

  yuv8_video_out.y                  = NULL;
  yuv8_video_out.u                  = NULL;
  yuv8_video_out.v                  = NULL;
  yuv8_video_out.rows               = rows;
  yuv8_video_out.cols               = cols;
  yuv8_video_out.frames             = 1;
  yuv8_video_out.chroma_format      = chroma;
  yuv8_video_out.bits_per_component = 8;

  video_out.rows               = rows;
  video_out.cols               = cols;
  video_out.frames             = 1;
  video_out.mode               = chroma;
  video_out.bits_per_component = 8;
  video_out.data[0]            = NULL;
  video_out.data[1]            = NULL;
  video_out.data[2]            = NULL;
  
  if ((out_fid = fopen(out_filename, "w+b" )) == NULL ) {
    printf( "Could not create file for writing\n" );
    exit(1);
  }

  if ( alloc_yuv8_frame_buff(&yuv8_video_out) > 0) exit(1);
  if ( alloc_video_buff(&video_out) > 0) exit(1);

  for (frame = 0; frame<frames; frame++) {
    printf("Converting from YC\n");

    yc_out = out_frames[frame];

    for (row = 0; row < video_out.rows; row++) {
      for (col = 0; col < video_out.cols; col++) {
        int ccol;
        
        yc_out_tmp1 = yc_out[row*NUMCOLS + col];
        yc_out_tmp2 = yc_out_tmp1;

        yc_out_tmp1 = (yc_out_tmp1 >> 8) & 0x00ff;
        video_out.data[0][0][row][col] = yc_out_tmp1;

        if (!(col & 1)) {
          ccol = col/2;
          video_out.data[1][0][row][ccol] = yc_out_tmp2 & 0x00ff;
        }
        else {
          ccol = col/2;
          video_out.data[2][0][row][ccol] = yc_out_tmp2 & 0x00ff;
        }
      }
    }
    
    printf("Copying to video\n");
    copy_video_to_yuv8(&video_out, &yuv8_video_out);

    printf("Writing to disk: frame %d\n", frame);
    if (write_yuv8(out_fid, &(yuv8_video_out))>0) {
      exit(1);
    }
  }
  free_yuv_frame_buff((struct yuv_video_struct *)&yuv8_video_out);
  free_video_buff(&video_out) ;
  return 1;
}


int read_frames(char* in_filename, int frames, int rows, int cols, int chroma)
{
  
  FILE* input_fid = NULL;
  
  unsigned short *yc_in;
  struct video_struct current_video_in; 
  struct video_struct previous_video_in; 
  struct yuv8_video_struct yuv8_video_in ;
  int frame, row, col;
  
  TIME_STAMP_INIT
    
  // Initialize input parameters
    
  yuv8_video_in.y                           =  NULL;
  yuv8_video_in.u                           =  NULL;
  yuv8_video_in.v                           =  NULL;
  yuv8_video_in.rows                        =  rows;
  yuv8_video_in.cols                        =  cols;
  yuv8_video_in.frames                      =  1;
  yuv8_video_in.chroma_format               =  chroma;
  yuv8_video_in.bits_per_component          =  8;
  
  current_video_in.rows                    =  rows;
  current_video_in.cols                    =  cols;
  current_video_in.frames                  =  1;
  current_video_in.mode                    =  chroma;
  current_video_in.bits_per_component      =  8;
  current_video_in.data[0]                 =  NULL;
  current_video_in.data[1]                 =  NULL;
  current_video_in.data[2]                 =  NULL;
  
  previous_video_in.rows                    =  rows;
  previous_video_in.cols                    =  cols;
  previous_video_in.frames                  =  1;
  previous_video_in.mode                    =  chroma;
  previous_video_in.bits_per_component      =  8;
  previous_video_in.data[0]                 =  NULL;
  previous_video_in.data[1]                 =  NULL;
  previous_video_in.data[2]                 =  NULL;
  
  //  Open files
  if ( (input_fid = fopen(in_filename, "r+b" )) == NULL ) {
    printf( "Could not open input yuv file\n" );
    exit(1);
  }
  
  if ( alloc_yuv8_frame_buff(&yuv8_video_in) > 0) exit(1);
  if ( alloc_video_buff(&current_video_in) > 0) exit(1);
  if ( alloc_video_buff(&previous_video_in) > 0)exit(1);
  
  for (frame = 0; frame < frames; frame++) {
    printf("Alloc frame %d\n", frame);
    in_frames[frame] = (unsigned short *) malloc(NUMROWS*NUMCOLS*sizeof(unsigned short));
    if (in_frames[frame] == NULL) {
      printf("unable to allocate frame %d\n", frame);
      exit(1);
    }
  }
  for (frame = 0; frame < frames; frame++) {
    printf("Alloc frame %d\n", frame);
    out_frames[frame] = (unsigned short *) malloc(NUMROWS*NUMCOLS*sizeof(unsigned short));
    if (out_frames[frame] == NULL) {
      printf("unable to allocate out frame %d\n", frame);
      exit(1);
    }
  }
  yc_out_tmp = (unsigned short *) malloc(NUMROWS*NUMCOLS*sizeof(unsigned short));
  yc_in_prev = (unsigned short *) malloc(NUMROWS*NUMCOLS*sizeof(unsigned short));
  if (yc_out_tmp == NULL || yc_in_prev == NULL) {
    printf("unable to allocate tmp frames\n");
    exit(1);
  }
  
  // Read all frames of YUV file contents into the input frame buffers
  unsigned short yc_in_tmp,  u_in_tmp,  v_in_tmp=0;
  for (frame = 0; frame<frames; frame++) {
    printf("Reading from disk: frame %d\n", frame);
    if (read_yuv8(input_fid, &(yuv8_video_in))>0) {
      exit(1);
    }
    printf("Copying to video\n");
    copy_yuv8_to_video(&yuv8_video_in, &(current_video_in));
    printf("Converting to YC\n");
    for (row = 0; row < current_video_in.rows; row++) {
      for (col = 0; col < current_video_in.cols; col++) {
        int ccol;
        yc_in_tmp = (current_video_in.data[0][0][row][col]);
        yc_in_tmp = (yc_in_tmp << 8) & 0xff00 ;
        if (!(col & 1)) {
          ccol = col/2;
          u_in_tmp = 0x00ff & (current_video_in.data[1][0][row][ccol]);
          v_in_tmp = 0x00ff & (current_video_in.data[2][0][row][ccol]);
          yc_in_tmp = yc_in_tmp  | u_in_tmp;
        }
        else {
          yc_in_tmp = yc_in_tmp | v_in_tmp;
        }
        yc_in = in_frames[frame];
        yc_in[row*NUMCOLS + col] = yc_in_tmp;
        if(frame == 0) {
          yc_in_prev[row*NUMCOLS + col] = yc_in_tmp;
        }
      }
    }
  }
  printf("... finished reading frames.\n");
  
  
  fclose(input_fid);
  free_yuv_frame_buff((struct yuv_video_struct *)&yuv8_video_in);
  free_video_buff(&current_video_in) ;
  free_video_buff(&previous_video_in);

  TIME_STAMP

  return 1;
}


int process_frames( int frames, int nr_strength)
{
  
  unsigned short *manr_in_current, *manr_in_prev;
  printf("Processing %d frames\n", frames);
  for (int frame = 0; frame<frames; frame++) {
    printf("Processing frame %d\n", frame);
    
    if(frame == 0) {
      manr_in_current = in_frames[0];
      manr_in_prev = yc_in_prev;
    }
    else {
      manr_in_current = in_frames[frame];
      manr_in_prev = in_frames[frame-1];
    }
    
    TIME_STAMP_INIT
    printf("Calling manr\n");

    manr( nr_strength,manr_in_current, manr_in_prev, yc_out_tmp);
    
    sobel_filter(yc_out_tmp, out_frames[frame]);
    
    TIME_STAMP
  }
  printf("... processing done.\n");
  
  return 1;
}

int main( int argc, char* argv[] )
{
#define MAX_FILE_NAME_LEN 2048
#define MAX_FILE_EXT_LEN 16
#define CHROMA 2
  char  in_filename[MAX_FILE_NAME_LEN] = { 0 };
  char  out_filename[MAX_FILE_NAME_LEN] = { 0 };
  char  in_ext[MAX_FILE_EXT_LEN];
  int   frames;
  int   rows = NUMROWS;
  int   cols = NUMCOLS;
  int   nr_strength;
  
  if (argc != 5)
    exit(print_help(argv[0]));
  
  strcpy(in_filename,  argv[1]);
  strcpy(out_filename,  argv[4]);
  strcpy( in_ext, strrchr(in_filename,'.')+1 );
  if (strcmp(in_ext, "yuv")==0) {
    frames      =  atoi( argv[2] );
    nr_strength =  atoi( argv[3] );
    if (frames > MAX_FRAMES)
      frames = MAX_FRAMES;
    
    read_frames(in_filename, frames, rows, cols, CHROMA);
    process_frames(frames, nr_strength);
    write_frames(out_filename, frames, rows, cols, CHROMA);
    free_frames(frames);
  }
  else {
    printf("\nInput file format not recognized!\n");
    return(1);
  }
  return(0);
}

// XSIP watermark, do not delete 67d7842dbbe25473c3c32b93c0da8047785f30d78e8a024de1b57352245f9689
