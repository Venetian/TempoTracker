//
//  accFFT.cpp
//  AccelerateFFTtool
//
//  Created by Adam Stark on 17/07/2012.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#include "accFFT.h"
#include <stdlib.h>


accFFT :: accFFT(int fft_size,int type)
{
    fft_type = type;
    
    fftSize = fft_size;           
    fftSizeOver2 = fftSize/2;
    log2n = log2f(fftSize);  
    log2nOver2 = log2n/2;
    
    if (fft_type == 0)
    {
        split.realp = (float *) malloc(fftSize * sizeof(float));
        split.imagp = (float *) malloc(fftSize * sizeof(float));
        
        // allocate the fft object once
        fftSetup = vDSP_create_fftsetup(log2n, FFT_RADIX2);
        if (fftSetup == NULL) {
            //printf("FFT Setup failed\n");
        }
    }
    else if (fft_type == 1) 
    {
        d_split.realp = (double *) malloc(fftSize * sizeof(double));
        d_split.imagp = (double *) malloc(fftSize * sizeof(double));
        
        // allocate the fft object once
        fftSetupD = vDSP_create_fftsetupD(log2n, FFT_RADIX2);
        if (fftSetupD == NULL) {
            //printf("FFT Setup failed\n");
        }
    }
        
    
    
}

accFFT :: ~accFFT()
{
    if (fft_type == 0)
    {
        free(split.realp);
        free(split.imagp);
        vDSP_destroy_fftsetup(fftSetup);
    }
    else if (fft_type == 1)
    {
        free(d_split.realp);
        free(d_split.imagp);
        vDSP_destroy_fftsetupD(fftSetupD);
    }
    
    
}

void accFFT :: forward_FFT_f(float *buffer,float *real,float *imag)
{        
    //convert to split complex format with evens in real and odds in imag
    vDSP_ctoz((COMPLEX *) buffer, 2, &split, 1, fftSizeOver2);
    
    //calc fft
    vDSP_fft_zrip(fftSetup, &split, 1, log2n, FFT_FORWARD);
    
    // set Nyquist component to imaginary of 0 component
    split.realp[fftSizeOver2] = split.imagp[0];
    split.imagp[fftSizeOver2] = 0.0;
    
    // set 0 component to zero
    split.imagp[0] = 0.0;
    
    // multiply by 0.5 to get correct output (to do with Apple's FFT implementation)
    for (i = 0; i <= fftSizeOver2; i++)
    {
        split.realp[i] *= 0.5;
        split.imagp[i] *= 0.5;
    }
    
    // set values above N/2+1 which are complex conjugate mirror image of those below
    for (i = fftSizeOver2 - 1;i > 0;--i)
    {
        split.realp[2*fftSizeOver2 - i] = split.realp[i];
        split.imagp[2*fftSizeOver2 - i] = -1*split.imagp[i];
        
        //cout << split_data.realp[2*fftSizeOver2 - i] << "   " << split_data.imagp[2*fftSizeOver2 - i] << "i" << endl;
    }
    
    for (i = 0;i < fftSize;i++)
    {
        real[i] = split.realp[i];
        imag[i] = split.imagp[i];
    }
}



void accFFT :: forward_FFT_d(double *buffer,fft_complex *out)
{        
    //convert to split complex format with evens in real and odds in imag
    vDSP_ctozD((DOUBLE_COMPLEX *) buffer, 2, &d_split, 1, fftSizeOver2);
    
    //calc fft
    vDSP_fft_zripD(fftSetupD, &d_split, 1, log2n, FFT_FORWARD);
    
    // set Nyquist component to imaginary of 0 component
    d_split.realp[fftSizeOver2] = d_split.imagp[0];
    d_split.imagp[fftSizeOver2] = 0.0;
    
    // set 0 component to zero
    d_split.imagp[0] = 0.0;
    
    // multiply by 0.5 to get correct output (to do with Apple's FFT implementation)
    for (i = 0; i <= fftSizeOver2; i++)
    {
        d_split.realp[i] *= 0.5;
        d_split.imagp[i] *= 0.5;
    }
    
    // set values above N/2+1 which are complex conjugate mirror image of those below
    for (i = fftSizeOver2 - 1;i > 0;--i)
    {
        d_split.realp[2*fftSizeOver2 - i] = d_split.realp[i];
        d_split.imagp[2*fftSizeOver2 - i] = -1*d_split.imagp[i];
    }
    
    for (i = 0;i < fftSize;i++)
    {
        out[i][0] = d_split.realp[i]; 
        out[i][1] = d_split.imagp[i];
    }
}