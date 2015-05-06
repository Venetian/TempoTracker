/*
 *  OnsetDetectionFunction.h
 *  
 *
 *  Created by Adam Stark on 22/03/2011.
 *  Copyright 2011 Queen Mary University of London. All rights reserved.
 *
 */

#ifndef __RTONSETDF_H
#define __RTONSETDF_H

//#include "fftw3.h"
#include "accFFT.h"

typedef double fft_complex[2];

class OnsetDetectionFunction
{
public:
	OnsetDetectionFunction();																// Constructor
	OnsetDetectionFunction(int arg_hsize,int arg_fsize,int arg_df_type,int arg_win_type);	// Constructor (with arguments)
	~OnsetDetectionFunction();																// Destructor
	void initialise(int arg_hsize,int arg_fsize,int arg_df_type,int arg_win_type);			// Initialisation Function
	
	double getDFsample(double inputbuffer[]);												// process input buffer and calculate detection function sample
	void set_df_type(int arg_df_type);														// set the detection function type
	
private:
	
	void perform_FFT();																		// perform the FFT on the data in 'frame'

	double energy_envelope();																// calculate energy envelope detection function sample
	double energy_difference();																// calculate energy difference detection function sample
	double spectral_difference();															// calculate spectral difference detection function sample
	double spectral_difference_hwr();														// calculate spectral difference (half wave rectified) detection function sample
	double phase_deviation();																// calculate phase deviation detection function sample
	double complex_spectral_difference();													// calculate complex spectral difference detection function sample
	double complex_spectral_difference_hwr();												// calculate complex spectral difference detection function sample (half-wave rectified)
	double high_frequency_content();														// calculate high frequency content detection function sample
	double high_frequency_spectral_difference();											// calculate high frequency spectral difference detection function sample
	double high_frequency_spectral_difference_hwr();										// calculate high frequency spectral difference detection function sample (half-wave rectified)

	void set_win_rectangular();																// calculate a Rectangular window	
	void set_win_hanning();																	// calculate a Hanning window
	void set_win_hamming();																	// calculate a Hamming window
	void set_win_blackman();																// calculate a Blackman window
	void set_win_tukey();																	// calculate a Tukey window

	
	double princarg(double phaseval);														// set phase values between [-pi, pi]
	
	
	double pi;																				// pi, the constant
	
	int framesize;																			// audio framesize
	int hopsize;																			// audio hopsize	
	int df_type;																			// type of detection function
	
    accFFT *fft;
    fft_complex *out;
    double *in;
    
	//fftw_plan p;																			// create fft plan
	//fftw_complex *in;																		// to hold complex fft values for input
	//fftw_complex *out;																		// to hold complex fft values for output
    
	
	int initialised;																		// flag indicating whether buffers and FFT plans have been initialised
	

	double *frame;																			// audio frame
	double *window;																			// window
	double *wframe;																			// windowed frame
	
	double energy_sum_old;																	// to hold the previous energy sum value
	
	double *mag;																			// magnitude spectrum
	double *mag_old;																		// previous magnitude spectrum
	
	double *phase;																			// FFT phase values
	double *phase_old;																		// previous phase values
	double *phase_old_2;																	// second order previous phase values

};


#endif