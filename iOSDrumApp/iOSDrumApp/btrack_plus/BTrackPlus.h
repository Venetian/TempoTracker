/*
 *  BTrackPlus.h
 *  BTrackPlus
 *
 *  Adam Stark, Andrew Roberston, Matthew Davies and Mark Plumbley
 *  2012
 *
 */

#ifndef __BTRACKPLUS_H
#define __BTRACKPLUS_H

//#include "fftw3.h"

class BTrackPlus {
	
public:
	BTrackPlus();				// constructor
	~BTrackPlus();				// destructor	
	
	void initialise(int fsize);
	void process(float df_sample);
	void plotdfbuffer();
	void updatecumscore(float df_sample);
	void predictbeat();
	void dfconvert();
	void calcTempo();
	void adapt_thresh(float x[],int N);
	float mean_array(float array[],int start,int end);
	void normalise(float array[],int N);
	void acf_bal(float df_thresh[]);
	void getrcfoutput();
	void settempo(float tempo);
	void fixtempo(float tempo);
	void unfixtempo();
	int getTimeToBeat();
    
    
	int playbeat;
	float cscoreval;
	float est_tempo;
			
private:
	
	// buffers
	float *dfbuffer;			// to hold detection function
	float df512[512];			// to hold resampled detection function 
	float *cumscore;			// to hold cumulative score
	
	float acf[512];				// to hold autocorrelation function
	
	float wv[128];				// to hold weighting vector
	
	float rcf[128];				// to hold comb filter output
	float t_obs[41];			// to hold tempo version of comb filter output
	
	float delta[41];			// to hold final tempo candidate array
	float prev_delta[41];		// previous delta
	float prev_delta_fix[41];	// fixed tempo version of previous delta
	
	float t_tmat[41][41];		// transition matrix
	
	
	// parameters
	float tightness;
	float alpha;
	float bperiod;
	float tempo;
	
	
	float p_fact;
	
	
	//
	int m0;				// indicates when the next point to predict the next beat is
	int beat;
	
	int dfbuffer_size;
		
	
	int framesize;
	
	
	int tempofix;
	

};

#endif
