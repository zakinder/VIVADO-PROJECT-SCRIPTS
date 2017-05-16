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
// ANSI C definitions for the functions declared in rgb_utils.h
//
//  gaborz   02/03/2010: Original creation
//  gaborz   03/03/2010: Version checked into the common repository

#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#include "rgb_utils.h"
#include "video_utils.h"



unsigned char* allocbuff8(int depth)
{
  unsigned char* ret = (unsigned char*) calloc(depth, sizeof(unsigned char));
  if (ret == NULL) { printf("Not enough memory to allocate image buffer!\n"); return(0); }
  return ret;
}

unsigned char** allocbuff8p(int depth)
{
  unsigned char** ret = (unsigned char**) calloc(depth, sizeof(unsigned char*));
  if (ret == NULL) { printf("Not enough memory to allocate image buffer!\n"); return(0); }
  return ret;
}

unsigned short* allocbuff16(int depth)
{
  unsigned short* ret = (unsigned short*) calloc(depth, sizeof(unsigned short));
  if (ret == NULL) { printf("Not enough memory to allocate image buffer!\n"); return(0); }
  return ret;
}

unsigned short** allocbuff16p(int depth)
{
  unsigned short** ret = (unsigned short**) calloc(depth, sizeof(unsigned short*));
  if (ret == NULL) { printf("Not enough memory to allocate image buffer!\n"); return(0); }
  return ret;
}

int alloc_rgb_frame_buff(struct rgb_video_struct* rgb_video )
{   
  int frame, row;

  if ((rgb_video->r = (unsigned short ***) allocbuff16p( rgb_video->frames )) == 0) return(1);
  if ((rgb_video->g = (unsigned short ***) allocbuff16p( rgb_video->frames )) == 0) return(1);
  if ((rgb_video->b = (unsigned short ***) allocbuff16p( rgb_video->frames )) == 0) return(1);
  for (frame = 0; frame < rgb_video->frames; frame++) {
    if ((rgb_video->r[frame] = (unsigned short **) allocbuff16p(rgb_video->rows)) == 0) return(1);
    if ((rgb_video->g[frame] = (unsigned short **) allocbuff16p(rgb_video->rows)) == 0) return(1);
    if ((rgb_video->b[frame] = (unsigned short **) allocbuff16p(rgb_video->rows)) == 0) return(1);
    for (row = 0; row < rgb_video->rows; row++) {
      if ((rgb_video->r[frame][row] = allocbuff16(rgb_video->cols)) == 0) return(1);
      if ((rgb_video->g[frame][row] = allocbuff16(rgb_video->cols)) == 0) return(1);
      if ((rgb_video->b[frame][row] = allocbuff16(rgb_video->cols)) == 0) return(1);
    }
  }
  return(0);
}

int alloc_rgb8_frame_buff(struct rgb8_video_struct* rgb_video )
{   
  int frame, row;

  if ((rgb_video->r = (unsigned char ***) allocbuff8p( rgb_video->frames )) == 0) return(1);
  if ((rgb_video->g = (unsigned char ***) allocbuff8p( rgb_video->frames )) == 0) return(1);
  if ((rgb_video->b = (unsigned char ***) allocbuff8p( rgb_video->frames )) == 0) return(1);
  for (frame = 0; frame < rgb_video->frames; frame++) {
    if ((rgb_video->r[frame] = (unsigned char **) allocbuff8p(rgb_video->rows)) == 0) return(1);
    if ((rgb_video->g[frame] = (unsigned char **) allocbuff8p(rgb_video->rows)) == 0) return(1);
    if ((rgb_video->b[frame] = (unsigned char **) allocbuff8p(rgb_video->rows)) == 0) return(1);
    for (row = 0; row < rgb_video->rows; row++) {
      if ((rgb_video->r[frame][row] = allocbuff8(rgb_video->cols)) == 0) return(1);
      if ((rgb_video->g[frame][row] = allocbuff8(rgb_video->cols)) == 0) return(1);
      if ((rgb_video->b[frame][row] = allocbuff8(rgb_video->cols)) == 0) return(1);
    }
  }
  return(0);
}

void free_rgb_frame_buff(struct rgb8_video_struct* rgb_video )
{   
  int frame, row;

  if (rgb_video->r != NULL) {
    for (frame = 0; frame < rgb_video->frames; frame++) {
      for (row = 0; row < rgb_video->rows; row++) if (rgb_video->r[frame][row] != NULL) free(rgb_video->r[frame][row]);
      if (rgb_video->r[frame] != NULL) free(rgb_video->r[frame]);
    }
    free(rgb_video->r);
  }

  if (rgb_video->g != NULL) {
    for (frame = 0; frame < rgb_video->frames; frame++) {
      for (row = 0; row < rgb_video->rows; row++) if (rgb_video->g[frame][row] != NULL)  free(rgb_video->g[frame][row]);
       if (rgb_video->g[frame] != NULL) free(rgb_video->g[frame]);
    }
    free(rgb_video->g);
  }

  if (rgb_video->b != NULL) {
    for (frame = 0; frame < rgb_video->frames; frame++) {
      for (row = 0; row < rgb_video->rows; row++)  if (rgb_video->b[frame][row] != NULL ) free(rgb_video->b[frame][row]);
       if (rgb_video->b[frame] != NULL) free(rgb_video->b[frame]);
    }
    free(rgb_video->b);
  }
}


// XSIP watermark, do not delete 67d7842dbbe25473c3c32b93c0da8047785f30d78e8a024de1b57352245f9689
