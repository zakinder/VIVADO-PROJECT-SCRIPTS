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
// Purpose : Header file declaring the general purpose video class
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
//-----------------------------------------------------------------------------
//
// ANSI C header file declaring
//  - video structure with programmable number of component planes
//  - video memory allocation and deallication functions
//  - video file read and write functions
//  - copy functions between rgb and generalized video data

#ifndef video_utils_h
#define video_utils_h

#include <stdio.h>

#ifndef  FORMAT_MONO                        // Some named constants have been defined in yuv_utils.h
#define  FORMAT_MONO    0
#define  FORMAT_C420    1
#define  FORMAT_C422    2
#define  FORMAT_C444    3
#endif

#define  FORMAT_MONO_M  4                   // Luminance and Motion (both planes having full resolution)
#define  FORMAT_C420_M  5                   // 420 YUV data + Motion
#define  FORMAT_C422_M  6                   // 422 YUV data + Motion
#define  FORMAT_C444_M  7                   // 444 YUV data + Motion
#define  FORMAT_RGB     8
#define  FORMAT_RGB_M   9                   // RGB data + Motion  (all planes having full resolution)
#define  FORMAT_RGB_A  10                   // RGB data + Alpha channel (all planes having full resolution)

#define  FORMAT_C420_A  FORMAT_C420_M       // 420 YUV data + Alpha
#define  FORMAT_C422_A  FORMAT_C422_M       // 422 YUV data + Alpha
#define  FORMAT_C444_A  FORMAT_C444_M       // 444 YUV data + Alpha
#include "frame_size.h"
struct video_struct{                        // Data structure to store video data up to 16 bits per char
  int       frames, rows, cols;
  int       bits_per_component;             // Required for compatibility
  int       mode;
  unsigned short*** data[5];
};

#ifdef  __cplusplus
extern "C" {
#endif


int alloc_video_buff(struct video_struct* video );
void free_video_buff(struct video_struct* video );

int video_rows_per_plane(struct video_struct* video, int plane);
int video_cols_per_plane(struct video_struct* video, int plane);
int video_planes_per_mode(int mode);

int read_video( FILE* infile,  struct video_struct* in_video);
int write_video(FILE* outfile, struct video_struct* out_video);

int copy_rgb8_to_video(struct rgb8_video_struct* rgb8_in, struct video_struct* video_out );
int copy_video_to_rgb8(struct video_struct* video_in, struct rgb8_video_struct* rgb8_out );

#ifdef  __cplusplus
};
#endif

#endif

// XSIP watermark, do not delete 67d7842dbbe25473c3c32b93c0da8047785f30d78e8a024de1b57352245f9689
