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
// name: mo_fft.c
// desc: fft impl - based on CARL distribution
//
// authors: code from San Diego CARL package
//          Ge Wang (gewang@cs.princeton.edu)
//          Perry R. Cook (prc@cs.princeton.edu)
//          Nicholas J. Bryan (njb@ccrma.stanford.edu)
//
//    date: 11.27.2003 - present
//    version: 1.0.0
//
// Mobile Music research @ CCRMA, Stanford University:
//     http://momu.stanford.edu/
//-----------------------------------------------------------------------------
#include "mo_fft.h"
#include <stdlib.h>
#include <math.h>




//-----------------------------------------------------------------------------
// name: hanning()
// desc: make window
//-----------------------------------------------------------------------------
void MoFFT::hanning( float * window, unsigned long length )
{
    unsigned long i;
    double pi, phase = 0, delta;
    
    pi = 4.*atan(1.0);
    delta = 2 * pi / (double) length;
    
    for( i = 0; i < length; i++ )
    {
        window[i] = (float)(0.5 * (1.0 - cos(phase)));
        phase += delta;
    }
}




//-----------------------------------------------------------------------------
// name: hamming()
// desc: make window
//-----------------------------------------------------------------------------
void MoFFT::hamming( float * window, unsigned long length )
{
    unsigned long i;
    double pi, phase = 0, delta;
    
    pi = 4.*atan(1.0);
    delta = 2 * pi / (double) length;
    
    for( i = 0; i < length; i++ )
    {
        window[i] = (float)(0.54 - .46*cos(phase));
        phase += delta;
    }
}




//-----------------------------------------------------------------------------
// name: blackman()
// desc: make window
//-----------------------------------------------------------------------------
void MoFFT::blackman( float * window, unsigned long length )
{
    unsigned long i;
    double pi, phase = 0, delta;
    
    pi = 4.*atan(1.0);
    delta = 2 * pi / (double) length;
    
    for( i = 0; i < length; i++ )
    {
        window[i] = (float)(0.42 - .5*cos(phase) + .08*cos(2*phase));
        phase += delta;
    }
}




//-----------------------------------------------------------------------------
// name: apply_window()
// desc: apply a window to data
//-----------------------------------------------------------------------------
void MoFFT::apply_window( float * data, float * window, unsigned long length )
{
    unsigned long i;
    
    for( i = 0; i < length; i++ )
        data[i] *= window[i];
}


static float PI ;
static float TWOPI ;
void bit_reverse( float * x, long N );


//-----------------------------------------------------------------------------
// name: rfft()
// desc: real value fft
//
//   these routines from the CARL software, spect.c
//   check out the CARL CMusic distribution for more source code
//
//   Note: MoMu modified-----------------------
//   if forward is true, rfft replaces N real data points in x with N/2 complex 
//   values representing the positive frequency half of their Fourier spectrum,
//   with x[1] replaced with the real part of the Nyquist frequency value.
//
//   if forward is false, rfft expects x to contain positive N/2 complex or N real values 
//   arranged as before, and replaces it with N real values.
//
//   N MUST be a power of 2.
//
//-----------------------------------------------------------------------------
void MoFFT::rfft( float * x, long N, unsigned int forward )
{
    
    static int first = 1 ;
    float c1, c2, h1r, h1i, h2r, h2i, wr, wi, wpr, wpi, temp, theta ;
    float xr, xi ;
    long i, i1, i2, i3, i4, N2p1 ;
    
    //Mopho modification to hopefully make the function prototype easier to parse
    N = N/2;
    
    if( first )
    {
        PI = (float) (4.*atan( 1. )) ;
        TWOPI = (float) (8.*atan( 1. )) ;
        first = 0 ;
    }
    
    theta = PI/N ;
    wr = 1. ;
    wi = 0. ;
    c1 = 0.5 ;
    
    if( forward )
    {
        c2 = -0.5 ;
        cfft( x, N, forward ) ;
        xr = x[0] ;
        xi = x[1] ;
    }
    else
    {
        c2 = 0.5 ;
        theta = -theta ;
        xr = x[1] ;
        xi = 0. ;
        x[1] = 0. ;
    }
    
    wpr = (float) (-2.*pow( sin( 0.5*theta ), 2. )) ;
    wpi = (float) sin( theta ) ;
    N2p1 = (N<<1) + 1 ;
    
    for( i = 0 ; i <= N>>1 ; i++ )
    {
        i1 = i<<1 ;
        i2 = i1 + 1 ;
        i3 = N2p1 - i2 ;
        i4 = i3 + 1 ;
        if( i == 0 )
        {
            h1r =  c1*(x[i1] + xr ) ;
            h1i =  c1*(x[i2] - xi ) ;
            h2r = -c2*(x[i2] + xi ) ;
            h2i =  c2*(x[i1] - xr ) ;
            x[i1] =  h1r + wr*h2r - wi*h2i ;
            x[i2] =  h1i + wr*h2i + wi*h2r ;
            xr =  h1r - wr*h2r + wi*h2i ;
            xi = -h1i + wr*h2i + wi*h2r ;
        }
        else
        {
            h1r =  c1*(x[i1] + x[i3] ) ;
            h1i =  c1*(x[i2] - x[i4] ) ;
            h2r = -c2*(x[i2] + x[i4] ) ;
            h2i =  c2*(x[i1] - x[i3] ) ;
            x[i1] =  h1r + wr*h2r - wi*h2i ;
            x[i2] =  h1i + wr*h2i + wi*h2r ;
            x[i3] =  h1r - wr*h2r + wi*h2i ;
            x[i4] = -h1i + wr*h2i + wi*h2r ;
        }
        
        wr = (temp = wr)*wpr - wi*wpi + wr ;
        wi = wi*wpr + temp*wpi + wi ;
    }
    
    if( forward )
        x[1] = xr ;
    else
        cfft( x, N, forward ) ;
}




//-----------------------------------------------------------------------------
// name: cfft()
// desc: complex value fft
//
//   these routines from CARL software, spect.c
//   check out the CARL CMusic distribution for more software
//
//   cfft replaces float array x containing NC complex values (2*NC float 
//   values alternating real, imagininary, etc.) by its Fourier transform 
//   if forward is true, or by its inverse Fourier transform ifforward is 
//   false, using a recursive Fast Fourier transform method due to 
//   Danielson and Lanczos.
//
//   NC MUST be a power of 2.
//
//-----------------------------------------------------------------------------
void MoFFT::cfft( float * x, long NC, unsigned int forward )
{
    float wr, wi, wpr, wpi, theta, scale ;
    long mmax, ND, m, i, j, delta ;
    ND = NC<<1 ;
    bit_reverse( x, ND ) ;
    
    for( mmax = 2 ; mmax < ND ; mmax = delta )
    {
        delta = mmax<<1 ;
        theta = TWOPI/( forward? mmax : -mmax ) ;
        wpr = (float) (-2.*pow( sin( 0.5*theta ), 2. )) ;
        wpi = (float) sin( theta ) ;
        wr = 1. ;
        wi = 0. ;
        
        for( m = 0 ; m < mmax ; m += 2 )
        {
            register float rtemp, itemp ;
            for( i = m ; i < ND ; i += delta )
            {
                j = i + mmax ;
                rtemp = wr*x[j] - wi*x[j+1] ;
                itemp = wr*x[j+1] + wi*x[j] ;
                x[j] = x[i] - rtemp ;
                x[j+1] = x[i+1] - itemp ;
                x[i] += rtemp ;
                x[i+1] += itemp ;
            }
            
            wr = (rtemp = wr)*wpr - wi*wpi + wr ;
            wi = wi*wpr + rtemp*wpi + wi ;
        }
    }
    
    // scale output
    scale = (float)(forward ? 1./ND : 2.) ;
    {
        register float *xi=x, *xe=x+ND ;
        while( xi < xe )
            *xi++ *= scale ;
    }
}




//-----------------------------------------------------------------------------
// name: bit_reverse()
// desc: bitreverse places float array x containing N/2 complex values
//       into bit-reversed order
//-----------------------------------------------------------------------------
void MoFFT::bit_reverse( float * x, long N )
{
    float rtemp, itemp ;
    long i, j, m ;
    for( i = j = 0 ; i < N ; i += 2, j += m )
    {
        if( j > i )
        {
            rtemp = x[j] ; itemp = x[j+1] ; /* complex exchange */
            x[j] = x[i] ; x[j+1] = x[i+1] ;
            x[i] = rtemp ; x[i+1] = itemp ;
        }
        
        for( m = N>>1 ; m >= 2 && j >= m ; m >>= 1 )
            j -= m ;
    }
}
