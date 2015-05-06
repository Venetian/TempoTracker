/*----------------------------------------------------------------------------
  MoMu: A Mobile Music Toolkit
  Copyright (c) 2010 Nicholas J. Bryan, Jorge Herrera, Jieun Oh, and Ge Wang
  All rights reserved.
    http://momu.stanford.edu/toolkit/
 
  Mobile Music Research @ CCRMA
  Music, Computing, Design Group
  Stanford University
    http://momu.stanford.edu/
    http://ccrma.stanford.edu/groups/mcd/
 
 MoMu is distributed under the following BSD style open source license:
 
 Permission is hereby granted, free of charge, to any person obtaining a 
 copy of this software and associated documentation files (the
 "Software"), to deal in the Software without restriction, including
 without limitation the rights to use, copy, modify, merge, publish,
 distribute, sublicense, and/or sell copies of the Software, and to
 permit persons to whom the Software is furnished to do so, subject to
 the following conditions:
 
 The authors encourage users of MoMu to include this copyright notice,
 and to let us know that you are using MoMu. Any person wishing to 
 distribute modifications to the Software is encouraged to send the 
 modifications to the original authors so that they can be incorporated 
 into the canonical version.
 
 The Software is provided "as is", WITHOUT ANY WARRANTY, express or implied,
 including but not limited to the warranties of MERCHANTABILITY, FITNESS
 FOR A PARTICULAR PURPOSE and NONINFRINGEMENT.  In no event shall the authors
 or copyright holders by liable for any claim, damages, or other liability,
 whether in an actino of a contract, tort or otherwise, arising from, out of
 or in connection with the Software or the use or other dealings in the 
 software.
 -----------------------------------------------------------------------------*/
//-----------------------------------------------------------------------------
// name: mo_fft.h
// desc: fft impl - based on CARL distribution
//
// authors: code from San Diego CARL package
//          Ge Wang (ge@ccrma.stanford.edu)
//          Perry R. Cook (prc@cs.princeton.edu)
//          Nicholas J. Bryan (njb@ccrma.stanford.edu)
//
//    date: 01.16.10
//    version: 1.0.0
//
// Mobile Music research @ CCRMA, Stanford University:
//     http://momu.stanford.edu/
//-----------------------------------------------------------------------------
#ifndef __MO_FFT_H__
#define __MO_FFT_H__


// complex type
typedef struct { float re ; float im ; } complex;

// complex absolute value
#define cmp_abs(x) ( sqrt( (x).re * (x).re + (x).im * (x).im ) )

#define FFT_FORWARD 1
#define FFT_INVERSE 0

class MoFFT
{
public:
    // real fft, N must be power of 2
    static void rfft( float * x, long N, unsigned int forward );

    // complex fft, NC must be power of 2
    static void cfft( float * x, long NC, unsigned int forward );

    // make window
    static void hanning( float * window, unsigned long length );
    static void hamming( float * window, unsigned long length );
    static void blackman( float * window, unsigned long length );

    // apply window
    static void apply_window( float * data, float * window, unsigned long length );

private:
    static void bit_reverse( float * x, long N );
};


#endif
