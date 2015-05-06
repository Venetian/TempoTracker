//
//  accFFT.h
//  AccelerateFFTtool
//
//  Created by Adam Stark on 17/07/2012.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#ifndef AccelerateFFTtool_accFFT_h
#define AccelerateFFTtool_accFFT_h

#include <Accelerate/Accelerate.h>

typedef double fft_complex[2];

class accFFT {
public:
    accFFT(int fft_size,int type);       // constructor
    ~accFFT();                  // destructor
    void forward_FFT_f(float *buffer,float *real,float *imag); // forward fft (float)
    void forward_FFT_d(double *buffer,fft_complex *out); // forward fft (double)
    

    
private:
    size_t              fftSize;
    size_t              fftSizeOver2;
    size_t              log2n;
    size_t              log2nOver2;
    size_t               i;                  
    
    FFTSetup            fftSetup;
    FFTSetupD           fftSetupD;
    COMPLEX_SPLIT       split;
    DOUBLE_COMPLEX_SPLIT d_split;
    
    int                  fft_type;
    
};

#endif
