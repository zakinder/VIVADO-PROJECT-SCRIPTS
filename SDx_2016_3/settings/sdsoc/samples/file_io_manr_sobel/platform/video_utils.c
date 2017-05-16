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

//-----------------------------------------------------------------------------
// Devices : All
// Library : Image and Video Processing
// Purpose : Bit accurate C model
//-----------------------------------------------------------------------------
//  (c) Copyright 2009 Xilinx, Inc. All rights reserved.
//
//  This file contains confidential and proprietary information
//  of Xilinx, Inc. and is protected under U.S. and
//  international copyright and other intellectual property
//  laws.
//
//  DISCLAIMER
//  This disclaimer is not a license and does not grant any
//  rights to the materials distributed herewith. Except as
//  otherwise provided in a valid license issued to you by
//  Xilinx, and to the maximum extent permitted by applicable
//  law: (1) THESE MATERIALS ARE MADE AVAILABLE "AS IS" AND
//  WITH ALL FAULTS, AND XILINX HEREBY DISCLAIMS ALL WARRANTIES
//  AND CONDITIONS, EXPRESS, IMPLIED, OR STATUTORY, INCLUDING
//  BUT NOT LIMITED TO WARRANTIES OF MERCHANTABILITY, NON-
//  INFRINGEMENT, OR FITNESS FOR ANY PARTICULAR PURPOSE; and
//  (2) Xilinx shall not be liable (whether in contract or tort,
//  including negligence, or under any other theory of
//  liability) for any loss or damage of any kind or nature
//  related to, arising under or in connection with these
//  materials, including for any direct, or any indirect,
//  special, incidental, or consequential loss or damage
//  (including loss of data, profits, goodwill, or any type of
//  loss or damage suffered as a result of any action brought
//  by a third party) even if such damage or loss was
//  reasonably foreseeable or Xilinx had been advised of the
//  possibility of the same.
//
//  CRITICAL APPLICATIONS
//  Xilinx products are not designed or intended to be fail-
//  safe, or for use in any application requiring fail-safe
//  performance, such as life-support or safety devices or
//  systems, Class III medical devices, nuclear facilities,
//  applications related to the deployment of airbags, or any
//  other applications that could lead to death, personal
//  injury, or severe property or environmental damage
//  (individually and collectively, "Critical
//  Applications"). Customer assumes the sole risk and
//  liability of any use of Xilinx products in Critical
//  Applications, subject only to applicable laws and
//  regulations governing limitations on product liability.
//
//  THIS COPYRIGHT NOTICE AND DISCLAIMER MUST BE RETAINED AS
//  PART OF THIS FILE AT ALL TIMES. 
//-------------------------------------------------------------------
//
// ANSI C source code defining the functions to:
//  - allocate and deallicate video structs,
//  - video file I/O,
//  - copy between rgb and generalized video data
//
//  gaborz   03/02/2010: Original creation
//  gaborz   03/03/2010: Version checked into the common repository


#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#include "rgb_utils.h"
#include "video_utils.h"



int video_rows_per_plane(struct video_struct* video, int plane)
{
  switch (video->mode) {
    case FORMAT_MONO:  
      return( (plane<1)*(video->rows) );                          // Monochrome image, 1 plane: luminance only
    case FORMAT_MONO_M:                                           // Luminance and Motion: 3 Planes
    case FORMAT_C444:
    case FORMAT_C422:
    case FORMAT_RGB:                                              // 3 Planes, equal sizes
      return( (plane<3)*(video->rows) ); break;
    case FORMAT_C420:                                             // 3 Planes, u and v (plane 1 and 2) have subsampled rows
      return((plane<3)*(video->rows >> (plane>0)) ); break;
    case FORMAT_RGB_A:                                            // 4 Planes, equal sizes
      return( (plane<4)*(video->rows) ); break;
    case FORMAT_C444_M:
    case FORMAT_C422_M:
    case FORMAT_RGB_M:
      return( (plane<5)*(video->rows) ); break;                   // 5 Planes, equal sizes
    case FORMAT_C420_M:                                           // 5 Planes, u and v (plane 1 and 2) have subsampled rows
      return((plane<5)*(video->rows >> ((plane==1) || (plane==2))) ); break;
  }
  return(0);
}

int video_cols_per_plane(struct video_struct* video, int plane)
{
  switch (video->mode) {
    case FORMAT_MONO:  
      return( (plane<1)*(video->cols) );                          // Monochrome image, 1 plane: luminance only
    case FORMAT_C444:
    case FORMAT_RGB:                                              
    case FORMAT_MONO_M:                                           // Luminance and Motion: 3 Planes
      return( (plane<3)*(video->cols) ); break;                   // 3 Planes, equal sizes
    case FORMAT_C420:
    case FORMAT_C422:                                             
      return((plane<3)*(video->cols >> (plane>0)) ); break;       // 3 Planes, u and v (plane 1 and 2) have subsampled rows
    case FORMAT_RGB_A:                                            
      return( (plane<4)*(video->cols) ); break;                   // 4 Planes, equal sizes
    case FORMAT_C444_M:
    case FORMAT_RGB_M:
      return( (plane<5)*(video->cols) ); break;                   // 5 Planes, equal sizes
    case FORMAT_C420_M:
    case FORMAT_C422_M:                                           // 5 Planes, u and v (plane 1 and 2) have subsampled rows
      return((plane<5)*(video->cols >> ((plane==1) || (plane==2))) ); break;
  }
  return(0);
}

int video_planes_per_mode(int mode)
{
    switch (mode) {
    case FORMAT_MONO_M:   return(3); break;
    case FORMAT_C444: 
    case FORMAT_RGB:
    case FORMAT_C420:
    case FORMAT_C422:     return(3); break;
    case FORMAT_RGB_A:    return(4); break;
    case FORMAT_C444_M:
    case FORMAT_RGB_M:
    case FORMAT_C420_M:
    case FORMAT_C422_M:   return(5); break;
    default :             return(1);     
  }
}

int alloc_video_buff(struct video_struct* video )
{   
  int frame, row, plane;

  for (plane = 0; plane < video_planes_per_mode(video->mode); plane++) {
    if ((video->data[plane] = (unsigned short ***) allocbuff16p( video->frames )) == 0) return(1);
    for (frame = 0; frame < video->frames; frame++) {
      if ((video->data[plane][frame] = (unsigned short **) allocbuff16p(video_rows_per_plane(video,plane))) == 0) return(1);
      for (row = 0; row < video_rows_per_plane(video,plane); row++) 
        if ((video->data[plane][frame][row] = allocbuff16(video_cols_per_plane(video,plane))) == 0) return(1);
    }
  }
  return(0);
}

void free_video_buff(struct video_struct* video )
{   
  int plane, frame, row;

  if (video->data[0] != NULL) {
    for (plane = 0; plane <video_planes_per_mode(video->mode); plane++) {
      for (frame = 0; frame < video->frames; frame++) {
        for (row = 0; row<video_rows_per_plane(video,plane); row++) { 
          free(video->data[plane][frame][row]); 
        }
        free(video->data[plane][frame]);
      }
      free(video->data[plane]);
    }
  }
}

int copy_rgb8_to_video(struct rgb8_video_struct* rgb8_in, struct video_struct* video_out )
{   
  int frame, row, col;
  int ret_val;

  if (rgb8_in == NULL) {    printf("Input rgb8 structure undefined!\n"); return(1); }
  if (rgb8_in->r == NULL) { printf("Input buffer not allocated!\n"); return(2); }
  if (video_out == NULL) {  printf("Output video structure undefined!\n"); return(4); }
  if (video_out->data[0] == NULL) {
    video_out->frames = rgb8_in->frames;
    video_out->rows   = rgb8_in->rows;
    video_out->cols   = rgb8_in->cols;
    video_out->mode   = FORMAT_RGB;
    // Allocate memory for the pixel array:
    if ((ret_val=alloc_video_buff(video_out)) > 0) return(ret_val);
  } else {
    if ((video_out->frames != rgb8_in->frames) || (video_out->rows != rgb8_in->rows) || (video_out->cols != rgb8_in->cols)) {
      printf("Preallocated output structure size mismatch!\n"); return(2); }
  }
  video_out->bits_per_component = rgb8_in->bits_per_component;
  video_out->mode = FORMAT_RGB;
  for (frame = 0; frame < rgb8_in->frames; frame++) 
    for (row = 0; row < rgb8_in->rows; row++) 
      for (col = 0; col < rgb8_in->cols; col++) {
        video_out->data[0][frame][row][col] = rgb8_in->r[frame][row][col];
        video_out->data[1][frame][row][col] = rgb8_in->g[frame][row][col];
        video_out->data[2][frame][row][col] = rgb8_in->b[frame][row][col];
      }
  return(0);
}

int copy_video_to_rgb8(struct video_struct* video_in, struct rgb8_video_struct* rgb8_out )
{   
  int frame, row, col;
  int ret_val, bitshift;

  if (video_in == NULL) {             printf("Input video structure undefined!\n"); return(1); }
  if (video_in->data[0] == NULL) {    printf("Input buffer not allocated!\n"); return(2); }
  if (rgb8_out == NULL) {             printf("Output rgb8 structure undefined!\n"); return(4); }
  if (video_in->mode != FORMAT_RGB) { printf("Input video format expected is RGB!\n"); return(8); }

  if (rgb8_out->r == NULL) {
    rgb8_out->frames = video_in->frames;
    rgb8_out->rows   = video_in->rows;
    rgb8_out->cols   = video_in->cols;
    rgb8_out->mode   = FORMAT_RGB;

    // Allocate memory for the pixel array:
    if ((ret_val=alloc_rgb8_frame_buff(rgb8_out)) > 0) return(ret_val);
  } else {
    if ((rgb8_out->frames != video_in->frames) || (rgb8_out->rows != video_in->rows) || (rgb8_out->cols != video_in->cols)) {
      printf("Preallocated output structure size mismatch!\n"); return(2); }
  }

  bitshift = mymax(0, video_in->bits_per_component-8); // Words may need bit shifting to fit into byte format
  for (frame = 0; frame < video_in->frames; frame++) 
    for (row = 0; row < video_in->rows; row++) 
      for (col = 0; col < video_in->cols; col++) {  
        rgb8_out->r[frame][row][col] = (unsigned char) ((video_in->data[0][frame][row][col])>>bitshift);
        rgb8_out->g[frame][row][col] = (unsigned char) ((video_in->data[1][frame][row][col])>>bitshift);
        rgb8_out->b[frame][row][col] = (unsigned char) ((video_in->data[2][frame][row][col])>>bitshift);
      }
  rgb8_out->bits_per_component=8;
  return(0);
}

int read_video(FILE* infile, struct video_struct* in_video)
{
  int plane, frame, row, col, ret_val;
  int frames, mode, rows, cols, bits_per_component;
  unsigned char byte;

  if (in_video == NULL) { printf("Input video structure undefined!\n"); return(1); }
  if (infile == NULL) { printf("Input file handler invalid!\n"); return(2); }
  if (fscanf(infile, "Mode: %d\nFrames: %d\nRows: %d\nCols: %d\nBits per Pixel: %d\n", &mode, &frames, &rows, &cols, &bits_per_component)<5) {
    video_rd_err: printf("\n  Error reading input video file!\n"); return(4); }

  if (in_video->data[0] == NULL) { 
    in_video->frames = frames;
    in_video->mode   = mode;
    in_video->rows   = rows;
    in_video->cols   = cols;
    in_video->bits_per_component = bits_per_component;

    // Allocate memory for the pixel array:
    if ((ret_val=alloc_video_buff(in_video)) > 0) return(ret_val);
  } else {
    if ((in_video->mode != mode) || (in_video->frames != frames) || (in_video->rows != rows) || (in_video->cols != cols)) {
      printf("Preallocated output structure size mismatch!\n"); return(3); }
  }

  if (bits_per_component>8) {
    for (frame = 0; frame < in_video->frames; frame++) {
      for (plane = 0; plane <video_planes_per_mode(in_video->mode); plane++)
        for (row = 0; row<video_rows_per_plane(in_video,plane); row++)
          if (fread(in_video->data[plane][frame][row], 2, video_cols_per_plane(in_video,plane), infile) != (unsigned int)cols) goto video_rd_err;
    }
  } else {
    for (frame = 0; frame < in_video->frames; frame++) {
      for (plane = 0; plane <video_planes_per_mode(in_video->mode); plane++)
        for (row = 0; row<video_rows_per_plane(in_video,plane); row++)
          for (col = 0; col < video_cols_per_plane(in_video,plane); col++) {
            if (fread(&byte, 1, 1, infile) != 1) goto video_rd_err;
            in_video->data[plane][frame][row][col] = (unsigned short) byte;
          }
    }
  }
  return(0);
}

int write_video(FILE* outfile, struct video_struct* out_video)
{
  int plane, frame, row, col;
  unsigned char byte;

  if (out_video == NULL) {          printf("Input video structure undefined!\n"); return(1); }
  if (out_video->data[0] == NULL) { printf("Input buffer not allocated!\n"); return(2); }
  if (outfile == NULL) { printf("Output file handler invalid!\n"); return(3); }

  if (fprintf(outfile, "Mode: %d\nFrames: %d\nRows: %d\nCols: %d\nBits per Pixel: %d\n", out_video->mode,out_video->frames, out_video->rows, out_video->cols, out_video->bits_per_component)<5) {
    video_wr_err: printf("\n  Error writing to output rgb file!\n"); return(4); }
  if (out_video->bits_per_component>8) {
    for (frame = 0; frame < out_video->frames; frame++) {
      for (plane = 0; plane <video_planes_per_mode(out_video->mode); plane++)
        for (row = 0; row<video_rows_per_plane(out_video,plane); row++)
          if (fwrite(out_video->data[plane][frame][row], video_cols_per_plane(out_video,plane), 2, outfile) != 2) goto video_wr_err;
    }
  } else {
    for (frame = 0; frame < out_video->frames; frame++) {
      for (plane = 0; plane <video_planes_per_mode(out_video->mode); plane++)
        for (row = 0; row<video_rows_per_plane(out_video,plane); row++)
          for (col = 0; col < video_cols_per_plane(out_video,plane); col++) {
            byte = (unsigned char) out_video->data[plane][frame][row][col];
            if (fwrite(&byte, 1, 1, outfile) != 1) goto video_wr_err;
          }
    }
  }
  return(0);
}

// XSIP watermark, do not delete 67d7842dbbe25473c3c32b93c0da8047785f30d78e8a024de1b57352245f9689
