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
// ANSI C header file declaring
//  - 8  bit yuv structure
//  - 16 bit yuv structure
//  - yuv memory allocation and deallication functions
//  - yuv file read and write functions
//  - chroma resampling functions
//
// YUV format: Image is scanned line-by-line, top to bottom, left to right.
//
// File format: no header; all luma pixels followed by all U pixels,
//              followed by all V pixels. Pixels are unsigned bytes or 16bit words.
//              Files may contain multiple frames.


#ifndef yuv_utils_h
#define yuv_utils_h

#define  FORMAT_MONO    0
#define  FORMAT_C420    1
#define  FORMAT_C422    2
#define  FORMAT_C444    3
#include <stdio.h>

struct yuv8_video_struct
{
  int      frames, rows, cols;
  int      bits_per_component;
  int      chroma_format;
  unsigned char*** y;
  unsigned char*** u;
  unsigned char*** v;
};

struct yuv_video_struct
{
  int       frames, rows, cols;
  int       bits_per_component;
  int       chroma_format;
  unsigned short*** y;
  unsigned short*** u;
  unsigned short*** v;
};

#ifdef  __cplusplus
extern "C" {
#endif

void get_chroma_size(struct yuv_video_struct* yuv_video, int* crows, int* ccols);
int alloc_yuv8_frame_buff(struct yuv8_video_struct* yuv8video );
int alloc_yuv_frame_buff(struct yuv_video_struct* yuv_video );
void free_yuv_frame_buff(struct yuv_video_struct* yuv_video );
int read_yuv8(FILE* infile, struct yuv8_video_struct* yuv_video);
int write_yuv8(FILE* outfile, struct yuv8_video_struct* yuv_video);
int read_yuv(FILE* infile, struct yuv_video_struct* yuv_video);
int write_yuv(FILE* outfile, struct yuv_video_struct* yuv_video);

int copy_yuv8_to_yuv( struct yuv8_video_struct* yuv_in, struct yuv_video_struct*  yuv_out );
int copy_yuv_to_yuv8( struct yuv_video_struct*  yuv_in, struct yuv8_video_struct* yuv_out );
int copy_yuv8_to_video( struct yuv8_video_struct* yuv_in, struct video_struct* video_out );
int copy_yuv_to_video(  struct yuv_video_struct*  yuv_in, struct video_struct* yideo_out );
int copy_video_to_yuv8( struct video_struct* video_in, struct yuv8_video_struct* yuv_out );
int copy_video_to_yuv(  struct video_struct* video_in, struct yuv_video_struct*  yuv_out  );

int yuv8_420to444(struct yuv8_video_struct* video_in, struct yuv8_video_struct* video_out);
int yuv8_422to444(struct yuv8_video_struct* video_in, struct yuv8_video_struct* video_out);
int yuv8_444to420(struct yuv8_video_struct* video_in, struct yuv8_video_struct* video_out);
int yuv8_444to422(struct yuv8_video_struct* video_in, struct yuv8_video_struct* video_out);

#ifdef  __cplusplus
};
#endif

#endif // defined yuv_utils_h

// XSIP watermark, do not delete 67d7842dbbe25473c3c32b93c0da8047785f30d78e8a024de1b57352245f9689
