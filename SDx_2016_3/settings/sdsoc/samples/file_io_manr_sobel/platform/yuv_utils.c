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
// Purpose : Header file declaring the YUV video class
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
// ANSI C definitions for the functions declared in yuv_utils.h
//
// Version history: 
//  gaborz   02/03/2010: Original creation
//  gaborz   03/03/2010: Version checked into the common repository

 
#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#include "rgb_utils.h"
#include "video_utils.h"
#include "yuv_utils.h"
 
#define  BUFSIZE        16384                      

void get_chroma_size(struct yuv_video_struct* yuv_video, int* crows, int* ccols)
{
  switch (yuv_video->chroma_format) {
    case FORMAT_C444: 
    case FORMAT_C444_M: 
      *crows = yuv_video->rows; 
      *ccols = yuv_video->cols; break;
    case FORMAT_C422: 
    case FORMAT_C422_M: 
      *crows = yuv_video->rows; 
      *ccols = yuv_video->cols >> 1; break;
    case FORMAT_C420: 
    case FORMAT_C420_M: 
      *crows = yuv_video->rows >> 1; 
      *ccols = yuv_video->cols >> 1; break;
    default         : *crows = 0        ; *ccols = 0        ; // Monochrome image, luminance only
  }
}

int alloc_yuv8_frame_buff(struct yuv8_video_struct* yuv8video )
{   
  int frame, row, crows, ccols;

  get_chroma_size( (struct yuv_video_struct*) yuv8video , &crows, &ccols);

  yuv8video->y = (unsigned char ***) allocbuff8p( yuv8video->frames );
  if (yuv8video->chroma_format > FORMAT_MONO) {
    if ((yuv8video->u = (unsigned char ***) allocbuff8p( yuv8video->frames )) == NULL) return(1);
    if ((yuv8video->v = (unsigned char ***) allocbuff8p( yuv8video->frames )) == NULL) return(1);
  }

  for (frame = 0; frame < yuv8video->frames; frame++) {
    if ((yuv8video->y[frame] = (unsigned char **) allocbuff8p(yuv8video->rows)) == NULL) return(1);
    for (row = 0; row < yuv8video->rows; row++) 
      if ((yuv8video->y[frame][row] = allocbuff8(yuv8video->cols)) == NULL) return(1);

    if (yuv8video->chroma_format > FORMAT_MONO) {
      if ((yuv8video->u[frame] = (unsigned char **) allocbuff8p(crows)) == NULL) return(1);
      if ((yuv8video->v[frame] = (unsigned char **) allocbuff8p(crows)) == NULL) return(1);
      for (row = 0; row < crows; row++) {
        if ((yuv8video->u[frame][row] = allocbuff8(ccols)) == NULL) return(1);
        if ((yuv8video->v[frame][row] = allocbuff8(ccols)) == NULL) return(1);
      }
    }
  }
  return(0);
}

void free_yuv_frame_buff(struct yuv_video_struct* yuv_video )
{   
  int frame, row, crows, ccols;
  get_chroma_size(yuv_video , &crows, &ccols);

  if (yuv_video->y != NULL) {
    for (frame = 0; frame < yuv_video->frames; frame++) {
      for (row = 0; row < yuv_video->rows; row++) if (yuv_video->y[frame][row] != NULL) free(yuv_video->y[frame][row]);
      free(yuv_video->y[frame]);
    }
    free(yuv_video->y);
  }

  if (yuv_video->chroma_format > FORMAT_MONO) {
    if (yuv_video->u != NULL) {
      for (frame = 0; frame < yuv_video->frames; frame++) {
        for (row = 0; row < crows; row++) if (yuv_video->u[frame][row] != NULL) free(yuv_video->u[frame][row]);
        if (yuv_video->u[frame] != NULL) free(yuv_video->u[frame]);
      }
      free(yuv_video->u);
    }
    if (yuv_video->v != NULL) {
      for (frame = 0; frame < yuv_video->frames; frame++) {
        for (row = 0; row < crows; row++) if (yuv_video->v[frame][row] != NULL) free(yuv_video->v[frame][row]);
        if (yuv_video->v[frame] != NULL) free(yuv_video->v[frame]);
      }
      free(yuv_video->v);
    }
  }
}

int alloc_yuv_frame_buff(struct yuv_video_struct* yuv_video )
{   
  int frame, row, crows, ccols;

  get_chroma_size(yuv_video , &crows, &ccols);

  if ((yuv_video->y = (unsigned short ***) allocbuff16p( yuv_video->frames )) == NULL) return(1);
  if (yuv_video->chroma_format > FORMAT_MONO) {
    if ((yuv_video->u = (unsigned short ***) allocbuff16p( yuv_video->frames )) == NULL) return(1);
    if ((yuv_video->v = (unsigned short ***) allocbuff16p( yuv_video->frames )) == NULL) return(1);
  }

  for (frame = 0; frame < yuv_video->frames; frame++) {
    if ((yuv_video->y[frame] = (unsigned short **) allocbuff16p(yuv_video->rows)) == NULL) return(1);
    for (row = 0; row < yuv_video->rows; row++) {
      if ((yuv_video->y[frame][row] = allocbuff16(yuv_video->cols)) == NULL) return(1); }

    if (yuv_video->chroma_format > FORMAT_MONO) {
      if ((yuv_video->u[frame] = (unsigned short **) allocbuff16p(crows)) == NULL) return(1);
      if ((yuv_video->v[frame] = (unsigned short **) allocbuff16p(crows)) == NULL) return(1);
      for (row = 0; row < crows; row++) {
        if ((yuv_video->u[frame][row] = allocbuff16(ccols)) == NULL) return(1);
        if ((yuv_video->v[frame][row] = allocbuff16(ccols)) == NULL) return(1);
      }
    }
  }
  return(0);
}

int read_yuv8(FILE* infile, struct yuv8_video_struct* yuv_video)
{
  int frame, row, crows, ccols;
  static int bytes_per_cc;

  bytes_per_cc = (int) (yuv_video->bits_per_component+7)/8;
  get_chroma_size((struct yuv_video_struct*) yuv_video , &crows, &ccols);

  // Verify that the video frame buffer associated with the video file has been allocated: 
  if (yuv_video->y == NULL) return(1); // No frame buffer was allocated

  for (frame = 0; frame < yuv_video->frames; frame++) 
  {
    for (row = 0; row < yuv_video->rows; row++) 
      if (fread(yuv_video->y[frame][row], bytes_per_cc, yuv_video->cols, infile) != (unsigned int)(yuv_video->cols)) {
        rderr: printf("\n  Error reading from input yuv file!\n"); return(2);
      }

    if (yuv_video->chroma_format > FORMAT_MONO) {
      for (row = 0; row < crows; row++) {
        if (fread(yuv_video->u[frame][row], ccols, 1, infile) != 1)  goto rderr;    }
      for (row = 0; row < crows; row++) {
        if (fread(yuv_video->v[frame][row], ccols, 1, infile) != 1)  goto rderr;    }
    }
  }
  return(0);
}

int read_yuv(FILE* infile, struct yuv_video_struct* yuv_video)
{
  int frame, row, crows, ccols;
  static int bytes_per_cc;

  bytes_per_cc = (int) (yuv_video->bits_per_component+7)/8;
  get_chroma_size((struct yuv_video_struct*) yuv_video , &crows, &ccols);

  // Verify that the video frame buffer associated with the video file has been allocated: 
  if (yuv_video->y == NULL) return(1); // No frame buffer was allocated

  for (frame = 0; frame < yuv_video->frames; frame++) 
  {
    for (row = 0; row < yuv_video->rows; row++) 
      if (fread(yuv_video->y[frame][row], bytes_per_cc, yuv_video->cols, infile) != (unsigned int)(yuv_video->cols)) {
        rderr: printf("\n  Error reading from input yuv file!\n"); return(2);
      }

    if (yuv_video->chroma_format > FORMAT_MONO) {
      for (row = 0; row < crows; row++) {
        if (fread(yuv_video->u[frame][row], ccols, 1, infile) != 1)  goto rderr;    }
      for (row = 0; row < crows; row++) {
        if (fread(yuv_video->v[frame][row], ccols, 1, infile) != 1)  goto rderr;    }
    }
  }
  return(0);
}

int write_yuv8(FILE* outfile, struct yuv8_video_struct* yuv_video)
{
  int frame, row, crows, ccols;
  static int bytes_per_cc;

  bytes_per_cc = (int) (yuv_video->bits_per_component+7)/8;
  get_chroma_size((struct yuv_video_struct*) yuv_video , &crows, &ccols);

  // Verify that the video frame buffer associated with the video file has been allocated: 
  if (yuv_video->y == NULL) return(1); // No frame buffer was allocated

  for (frame = 0; frame < yuv_video->frames; frame++) 
  {
    for (row = 0; row < yuv_video->rows; row++) 
      if (fwrite(yuv_video->y[frame][row], yuv_video->cols, bytes_per_cc, outfile) != 1) {
        wrerr: printf("\n  Error writing to output yuv file!\n"); return(2);
      }

    if (yuv_video->chroma_format>0) {
      for (row = 0; row < crows; row++) {
        if (fwrite(yuv_video->u[frame][row], ccols, 1, outfile) != 1)  goto wrerr;    }
      for (row = 0; row < crows; row++) {
        if (fwrite(yuv_video->v[frame][row], ccols, 1, outfile) != 1)  goto wrerr;    }
    }
  }
  return(0);
}

int write_yuv(FILE* outfile, struct yuv_video_struct* yuv_video)
{
  int frame, row, crows, ccols;
  static int bytes_per_cc;

  bytes_per_cc = (int) (yuv_video->bits_per_component+7)/8;
  get_chroma_size((struct yuv_video_struct*) yuv_video , &crows, &ccols);

  // Verify that the video frame buffer associated with the video file has been allocated: 
  if (yuv_video->y == NULL) return(1); // No frame buffer was allocated

  for (frame = 0; frame < yuv_video->frames; frame++) 
  {
    for (row = 0; row < yuv_video->rows; row++) 
      if (fwrite(yuv_video->y[frame][row], yuv_video->cols, bytes_per_cc, outfile) != 1) {
        wrerr: printf("\n  Error writing to output yuv file!\n"); return(2);
      }

    if (yuv_video->chroma_format>0) {
      for (row = 0; row < crows; row++) {
        if (fwrite(yuv_video->u[frame][row], ccols, 1, outfile) != 1)  goto wrerr;    }
      for (row = 0; row < crows; row++) {
        if (fwrite(yuv_video->v[frame][row], ccols, 1, outfile) != 1)  goto wrerr;    }
    }
  }
  return(0);
}

int verify_chroma_buffer(struct yuv_video_struct* video_in, struct yuv_video_struct* video_out, int chroma_in, int chroma_out)
{
  int cols = video_in->cols;
  int rows = video_in->rows;
  static char chroma_string[3][4]= { "20\0", "22\0", "44\0" };

  // Verify that the video frame buffer associated with the video file exists:
  if (video_in== NULL) {
    printf("Input video struct not defined!\n"); return(0x100); }

  if (video_in->y== NULL) {
    printf("Input video buffer does not exist!\n"); return(0x101); }

  if (video_out == NULL) {
    printf("Output video struct not defined!\n"); return(0x102); }

  if (video_in->chroma_format != chroma_in) {
    printf("Expected input format %s!\n", chroma_string[chroma_in-1]); return(0x103); }

  if (video_out->y == NULL) {
    video_out->chroma_format = chroma_out;
    video_out->frames = video_in->frames;
    video_out->rows = rows;
    video_out->cols = cols;
    video_out->bits_per_component = video_in->bits_per_component;   // reserved int is at the same location as  bits_per_component, allowing this function to work on yuv8_video 
    if (alloc_yuv_frame_buff( video_out )>0) return(1);  // Could not allocate frame buffer
  } else {
    if (video_out->chroma_format != chroma_out) {
      printf("Output buffer allocated is not %s format!\n", chroma_string[chroma_out-1]); return(0x104); }

    if ( (video_out->rows != rows) || (video_out->cols != cols) || (video_out->frames != video_in->frames)) {
      printf("Output buffer allocated is not the same size as the input buffer!\n"); return(0x105); }
  }
return(0);
}

int yuv8_420to444(struct yuv8_video_struct* video_in, struct yuv8_video_struct* video_out)
{
  int frame, row, col, rows, cols, j;

  cols  = video_in->cols;
  rows  = video_in->rows;
  // Verify that the video frame buffer associated with the video file exists:
  if ( (j=verify_chroma_buffer( (struct yuv_video_struct*) video_in, (struct yuv_video_struct*)  video_out, FORMAT_C420, FORMAT_C444))>0 )  return(j); 

  for (frame = 0; frame < video_in->frames; frame++)  {
    for (row = 0; row < rows; row++)
      for (col = 0; col < cols; col++) 
        video_out->y[frame][row][col] = video_in->y[frame][row][col];     // Luminance gets copied

  // Linear resampling according to page 22, Video Demystified, 4th edition by Keith Jack.
  // Interpolate U, V for all rows. Resampling u,v samples 
    for (row = 0; row < rows>>1; row++)
      for (col = 0; col < cols>>1; col++) {
        video_out->u[frame][row<<1][col<<1] = (unsigned char) (((video_in->u[frame][row][col])*3 + (video_in->u[frame][mymax(0,row-1)][col])) >> 2);
        video_out->v[frame][row<<1][col<<1] = (unsigned char) (((video_in->v[frame][row][col])*3 + (video_in->v[frame][mymax(0,row-1)][col])) >> 2);
      }

    for (row = 0; (1+(row<<1)) < rows; row++)
      for (col = 0; col < cols>>1; col++) {
        video_out->u[frame][1+(row<<1)][col<<1] = (unsigned char) ((( video_in->u[frame][row][col] )*3 + (video_in->u[frame][mymin((rows>>1)-1,row+1)][col])) >> 2);
        video_out->v[frame][1+(row<<1)][col<<1] = (unsigned char) ((( video_in->v[frame][row][col] )*3 + (video_in->v[frame][mymin((rows>>1)-1,row+1)][col])) >> 2);
      }

  // Interpolate the missing columns
    for (row = 0; row < rows; row++)                              // horizontal interpolation between 
      for (col = 0; col < cols-1; col+=2) {                       // upper and lower chrominances:
        video_out->u[frame][row][col+1] = (video_out->u[frame][row][col] + video_out->u[frame][row][mymin(cols-1,col+2)])>>1;
        video_out->v[frame][row][col+1] = (video_out->v[frame][row][col] + video_out->v[frame][row][mymin(cols-1,col+2)])>>1;
      }
  }
  return(0);
}

int yuv8_422to444(struct yuv8_video_struct* video_in, struct yuv8_video_struct* video_out)
{
  int frame, row, col, rows, cols, j;
  
  cols = video_in->cols;
  rows = video_in->rows;

  // Verify that the video frame buffer associated with the video file exists:
  if ( (j=verify_chroma_buffer((struct yuv_video_struct*) video_in, (struct yuv_video_struct*) video_out, FORMAT_C422, FORMAT_C444))>0 ) return(j);

  for (frame = 0; frame < video_in->frames; frame++)  {
    for (row = 0; row < rows; row++)
      for (col = 0; col < cols; col++) 
        video_out->y[frame][row][col] = video_in->y[frame][row][col];     // Luminance gets copied

    for (row = 0; row < rows; row++)
      for (col = 0; col < cols; col+=2) {
        video_out->u[frame][row][col] = video_in->u[frame][row][col>>1];     // Co-sited chrominance gets copied
        video_out->v[frame][row][col] = video_in->v[frame][row][col>>1]; 
      }

  // Interpolate the missing columns
    for (row = 0; row < rows; row++)                              // horizontal interpolation between 
      for (col = 0; col < cols-1; col+=2) {                       // upper and lower chrominances:
        video_out->u[frame][row][col+1] = (video_out->u[frame][row][col] + video_out->u[frame][row][mymin(cols-1,col+2)])>>1;
        video_out->v[frame][row][col+1] = (video_out->v[frame][row][col] + video_out->v[frame][row][mymin(cols-1,col+2)])>>1;
      }
  }
  return(0);
}

int yuv8_444to420(struct yuv8_video_struct* video_in, struct yuv8_video_struct* video_out)
{
  int frame, row, col, rows, cols, j;
  
  cols = video_in->cols;
  rows = video_in->rows;

  // Verify that the video frame buffer associated with the video file exists:
  if ( (j=verify_chroma_buffer((struct yuv_video_struct*)video_in, (struct yuv_video_struct*)video_out, FORMAT_C444, FORMAT_C420))>0 ) return(j); 

  for (frame = 0; frame < video_in->frames; frame++)  {
    for (row = 0; row < rows; row++)
      for (col = 0; col < cols; col++) 
        video_out->y[frame][row][col] = video_in->y[frame][row][col];     // Luminance gets copied

    for (row = 0; row < rows>>1; row++)                                     // Chrominance gets sub-sampled
      for (col = 0; col < cols>>1; col++) {
        video_out->u[frame][row][col] = ( (int) video_in->u[frame][row<<1][col<<1] + (int) video_in->u[frame][mymin((row<<1)+1,rows-1)][col<<1] ) >> 1;
        video_out->v[frame][row][col] = ( (int) video_in->v[frame][row<<1][col<<1] + (int) video_in->v[frame][mymin((row<<1)+1,rows-1)][col<<1] ) >> 1;
      }
  }
  return(0);
}

int yuv8_444to422(struct yuv8_video_struct* video_in, struct yuv8_video_struct* video_out)
{
  int frame, row, col, rows, cols, j;
  
  cols = video_in->cols;
  rows = video_in->rows;

  // Verify that the video frame buffer associated with the video file exists:
  if ( (j=verify_chroma_buffer((struct yuv_video_struct*) video_in, (struct yuv_video_struct*) video_out, FORMAT_C444, FORMAT_C422))>0 ) return(j); 

  for (frame = 0; frame < video_in->frames; frame++)  {
    for (row = 0; row < rows; row++)
      for (col = 0; col < cols; col++) 
        video_out->y[frame][row][col] = video_in->y[frame][row][col];     // Luminance gets copied

    for (row = 0; row < rows; row++)                                     // Chrominance gets sub-sampled
      for (col = 0; col < cols>>1; col++) {
        video_out->u[frame][row][col] = video_in->u[frame][row][col>>1] ;
        video_out->v[frame][row][col] = video_in->v[frame][row][col>>1] ;
      }
  }
  return(0);
}

int copy_yuv8_to_yuv( struct yuv8_video_struct* yuv_in, struct yuv_video_struct* yuv_out )
{
  int frame, row, col, crows, ccols;
  get_chroma_size((struct yuv_video_struct*) yuv_in , &crows, &ccols);

  // Verify that the video structs and frame buffers exist:
  if (yuv_in== NULL) {    printf("Input video struct not defined!\n"); return(0x100); }
  if (yuv_in->y== NULL) { printf("Input video buffer does not exist!\n"); return(0x101); }
  if (yuv_out == NULL) {  printf("Output video struct not defined!\n"); return(0x102); }
  if (yuv_out->y == NULL) {
    // Here is the default copy constructor
    yuv_out->chroma_format  = yuv_in->chroma_format;
    yuv_out->frames         = yuv_in->frames;
    yuv_out->rows           = yuv_in->rows;
    yuv_out->cols           = yuv_in->cols;
    if (alloc_yuv_frame_buff( yuv_out )>0) return(1);  // Could not allocate frame buffer
  } else {
    if ( (yuv_out->rows != yuv_in->rows) || (yuv_out->cols != yuv_in->cols) 
      || (yuv_out->frames != yuv_in->frames) || (yuv_out->chroma_format!= yuv_in->chroma_format)) {
      printf("Output buffer allocated is not the same size as the input buffer!\n"); return(0x105); }
  }
  
  yuv_out->bits_per_component = yuv_in->bits_per_component;

  for (frame = 0; frame < yuv_in->frames; frame++)  {
    for (row = 0; row < yuv_in->rows; row++)
      for (col = 0; col < yuv_in->cols; col++) 
        yuv_out->y[frame][row][col] = yuv_in->y[frame][row][col];     // Copy Luminance

    for (row = 0; row < crows; row++)
      for (col = 0; col < ccols; col++) {
        yuv_out->u[frame][row][col] = yuv_in->u[frame][row][col];     // Copy Chrominances
        yuv_out->v[frame][row][col] = yuv_in->v[frame][row][col];
      }
  }
  return(0);
}

int copy_yuv_to_yuv8( struct yuv_video_struct*  yuv_in,  struct yuv8_video_struct* yuv_out )
{
  int frame, row, col, crows, ccols;
  get_chroma_size((struct yuv_video_struct*) yuv_in , &crows, &ccols);

  // Verify that the video structs and frame buffers exist:
  if (yuv_in== NULL) {    printf("Input video struct not defined!\n"); return(0x100); }
  if (yuv_in->y== NULL) { printf("Input video buffer does not exist!\n"); return(0x101); }
  if (yuv_out == NULL) {  printf("Output video struct not defined!\n"); return(0x102); }
  if (yuv_out->y == NULL) {
    // Here is the default copy constructor
    yuv_out->chroma_format  = yuv_in->chroma_format;
    yuv_out->frames         = yuv_in->frames;
    yuv_out->rows           = yuv_in->rows;
    yuv_out->cols           = yuv_in->cols;
    if (alloc_yuv8_frame_buff( yuv_out )>0) return(1);  // Could not allocate frame buffer
  } else {
    if ( (yuv_out->rows != yuv_in->rows) || (yuv_out->cols != yuv_in->cols) 
      || (yuv_out->frames != yuv_in->frames) || (yuv_out->chroma_format!= yuv_in->chroma_format)) {
      printf("Output buffer allocated is not the same size as the input buffer!\n"); return(0x105); }
  }
  
  yuv_out->bits_per_component = yuv_in->bits_per_component;

  for (frame = 0; frame < yuv_in->frames; frame++)  {
    for (row = 0; row < yuv_in->rows; row++)
      for (col = 0; col < yuv_in->cols; col++) 
        yuv_out->y[frame][row][col] = (unsigned char) yuv_in->y[frame][row][col];     // Copy Luminance

    for (row = 0; row < crows; row++)
      for (col = 0; col < ccols; col++) {
        yuv_out->u[frame][row][col] = (unsigned char) yuv_in->u[frame][row][col];     // Copy Chrominances
        yuv_out->v[frame][row][col] = (unsigned char) yuv_in->v[frame][row][col];
      }
  }
  return(0);
}

int copy_yuv8_to_video( struct yuv8_video_struct* yuv_in, struct video_struct* video_out )
{
  int frame, row, col, crows, ccols;
  get_chroma_size( (struct yuv_video_struct*) yuv_in , &crows, &ccols);

  // Verify that the video structs and frame buffers exist:
  if (yuv_in== NULL) {    printf("Input video struct not defined!\n"); return(0x100); }
  if (yuv_in->y== NULL) { printf("Input video buffer does not exist!\n"); return(0x101); }
  if (video_out == NULL) {  printf("Output video struct not defined!\n"); return(0x102); }
  if (video_out->data == NULL) {
    // Here is the default copy constructor
    video_out->mode           = yuv_in->chroma_format;
    video_out->frames         = yuv_in->frames;
    video_out->rows           = yuv_in->rows;
    video_out->cols           = yuv_in->cols;
    if (alloc_video_buff( video_out )>0) return(1);  // Could not allocate frame buffer
  } else {
    if ( (video_out->rows != yuv_in->rows) || (video_out->cols != yuv_in->cols) ||
         (video_out->frames != yuv_in->frames) || 
         ((video_out->mode!= yuv_in->chroma_format) && 
          ((video_out->mode!=FORMAT_MONO_M || yuv_in->chroma_format!=FORMAT_MONO) &&
           (video_out->mode!=FORMAT_C420_M || yuv_in->chroma_format!=FORMAT_C420) &&
           (video_out->mode!=FORMAT_C422_M || yuv_in->chroma_format!=FORMAT_C422) &&
           (video_out->mode!=FORMAT_C444_M || yuv_in->chroma_format!=FORMAT_C444) ))) {
      printf("Output buffer allocated is not the same size as the input buffer!\n"); return(0x105); }
  }
  
  video_out->bits_per_component = yuv_in->bits_per_component;

  for (frame = 0; frame < yuv_in->frames; frame++)  {
    for (row = 0; row < yuv_in->rows; row++)
      for (col = 0; col < yuv_in->cols; col++) 
        video_out->data[0][frame][row][col] = yuv_in->y[frame][row][col];     // Copy Luminance

    for (row = 0; row < crows; row++)
      for (col = 0; col < ccols; col++) {
        video_out->data[1][frame][row][col] = yuv_in->u[frame][row][col];     // Copy Chrominances
        video_out->data[2][frame][row][col] = yuv_in->v[frame][row][col];
      }
  }
  return(0);
}

int copy_yuv_to_video( struct yuv_video_struct* yuv_in, struct video_struct* video_out )
{
  int frame, row, col, crows, ccols;
  get_chroma_size( (struct yuv_video_struct*) yuv_in , &crows, &ccols);

  // Verify that the video structs and frame buffers exist:
  if (yuv_in== NULL) {    printf("Input video struct not defined!\n"); return(0x100); }
  if (yuv_in->y== NULL) { printf("Input video buffer does not exist!\n"); return(0x101); }
  if (video_out == NULL) {  printf("Output video struct not defined!\n"); return(0x102); }
  if (video_out->data == NULL) {
    // Here is the default copy constructor
    video_out->mode           = yuv_in->chroma_format;
    video_out->frames         = yuv_in->frames;
    video_out->rows           = yuv_in->rows;
    video_out->cols           = yuv_in->cols;
    if (alloc_video_buff( video_out )>0) return(1);  // Could not allocate frame buffer
  } else {
    if ( (video_out->rows != yuv_in->rows) || (video_out->cols != yuv_in->cols) ||
         (video_out->frames != yuv_in->frames) || 
         ((video_out->mode!= yuv_in->chroma_format) && 
          ((video_out->mode!=FORMAT_MONO_M || yuv_in->chroma_format!=FORMAT_MONO) &&
           (video_out->mode!=FORMAT_C420_M || yuv_in->chroma_format!=FORMAT_C420) &&
           (video_out->mode!=FORMAT_C422_M || yuv_in->chroma_format!=FORMAT_C422) &&
           (video_out->mode!=FORMAT_C444_M || yuv_in->chroma_format!=FORMAT_C444) ))) {
      printf("Output buffer allocated is not the same size as the input buffer!\n"); return(0x105); }
  }
  
  video_out->bits_per_component = yuv_in->bits_per_component;

  for (frame = 0; frame < yuv_in->frames; frame++)  {
    for (row = 0; row < yuv_in->rows; row++)
      for (col = 0; col < yuv_in->cols; col++) 
        video_out->data[0][frame][row][col] = yuv_in->y[frame][row][col];     // Copy Luminance

    for (row = 0; row < crows; row++)
      for (col = 0; col < ccols; col++) {
        video_out->data[1][frame][row][col] = yuv_in->u[frame][row][col];     // Copy Chrominances
        video_out->data[2][frame][row][col] = yuv_in->v[frame][row][col];
      }
  }
  return(0);
}

int copy_video_to_yuv( struct video_struct* video_in, struct yuv_video_struct* yuv_out )
{
  int frame, row, col, crows, ccols;
  get_chroma_size( (struct yuv_video_struct*) video_in , &crows, &ccols);

  // Verify that the video structs and frame buffers exist:
  if (video_in== NULL) {          printf("Input video struct not defined!\n"); return(0x100); }
  if (video_in->data[0]== NULL) { printf("Input video buffer does not exist!\n"); return(0x101); }
  if (yuv_out == NULL) {          printf("Output video struct not defined!\n"); return(0x102); }
  if (yuv_out->y == NULL) {
    // Here is the default copy constructor
    yuv_out->chroma_format  = video_in->mode;
    yuv_out->frames         = video_in->frames;
    yuv_out->rows           = video_in->rows;
    yuv_out->cols           = video_in->cols;
    if (alloc_yuv_frame_buff( yuv_out )>0) return(1);  // Could not allocate frame buffer
  } else {
    if ( (video_in->rows != yuv_out->rows) || (video_in->cols != yuv_out->cols) ||
         (video_in->frames != yuv_out->frames) || 
         ((video_in->mode!= yuv_out->chroma_format) && 
          ((video_in->mode!=FORMAT_MONO_M || yuv_out->chroma_format!=FORMAT_MONO) &&
           (video_in->mode!=FORMAT_C420_M || yuv_out->chroma_format!=FORMAT_C420) &&
           (video_in->mode!=FORMAT_C422_M || yuv_out->chroma_format!=FORMAT_C422) &&
           (video_in->mode!=FORMAT_C444_M || yuv_out->chroma_format!=FORMAT_C444) ))) {
      printf("Output buffer allocated is not the same size as the input buffer!\n"); return(0x105); }
  }
  
  yuv_out->bits_per_component = video_in->bits_per_component;

  for (frame = 0; frame < video_in->frames; frame++)  {
    for (row = 0; row < video_in->rows; row++)
      for (col = 0; col < video_in->cols; col++) 
        yuv_out->y[frame][row][col] = video_in->data[0][frame][row][col];     // Copy Luminance

    for (row = 0; row < crows; row++)
      for (col = 0; col < ccols; col++) {
        yuv_out->u[frame][row][col] = video_in->data[1][frame][row][col];     // Copy Chrominances
        yuv_out->v[frame][row][col] = video_in->data[2][frame][row][col];
      }
  }
  return(0);
}

int copy_video_to_yuv8( struct video_struct* video_in, struct yuv8_video_struct* yuv_out )
{
  int frame, row, col, crows, ccols;
  get_chroma_size( (struct yuv_video_struct*) video_in , &crows, &ccols);

  // Verify that the video structs and frame buffers exist:
  if (video_in== NULL) {          printf("Input video struct not defined!\n"); return(0x100); }
  if (video_in->data[0]== NULL) { printf("Input video buffer does not exist!\n"); return(0x101); }
  if (yuv_out == NULL) {          printf("Output video struct not defined!\n"); return(0x102); }
  if (yuv_out->y == NULL) {
    // Here is the default copy constructor
    yuv_out->chroma_format  = video_in->mode;
    yuv_out->frames         = video_in->frames;
    yuv_out->rows           = video_in->rows;
    yuv_out->cols           = video_in->cols;
    if (alloc_yuv8_frame_buff( yuv_out )>0) return(1);  // Could not allocate frame buffer
  } else {
    if ( (video_in->rows != yuv_out->rows) || (video_in->cols != yuv_out->cols) ||
         (video_in->frames != yuv_out->frames) || 
         ((video_in->mode!= yuv_out->chroma_format) && 
          ((video_in->mode!=FORMAT_MONO_M || yuv_out->chroma_format!=FORMAT_MONO) &&
           (video_in->mode!=FORMAT_C420_M || yuv_out->chroma_format!=FORMAT_C420) &&
           (video_in->mode!=FORMAT_C422_M || yuv_out->chroma_format!=FORMAT_C422) &&
           (video_in->mode!=FORMAT_C444_M || yuv_out->chroma_format!=FORMAT_C444) ))) {
      printf("Output buffer allocated is not the same size as the input buffer!\n"); return(0x105); }
  }
  
  yuv_out->bits_per_component = video_in->bits_per_component;

  for (frame = 0; frame < video_in->frames; frame++)  {
    for (row = 0; row < video_in->rows; row++)
      for (col = 0; col < video_in->cols; col++) 
        yuv_out->y[frame][row][col] = (unsigned char) video_in->data[0][frame][row][col];     // Copy Luminance

    for (row = 0; row < crows; row++)
      for (col = 0; col < ccols; col++) {
        yuv_out->u[frame][row][col] = (unsigned char) video_in->data[1][frame][row][col];     // Copy Chrominances
        yuv_out->v[frame][row][col] = (unsigned char) video_in->data[2][frame][row][col];
      }
  }
  return(0);
}

// XSIP watermark, do not delete 67d7842dbbe25473c3c32b93c0da8047785f30d78e8a024de1b57352245f9689
