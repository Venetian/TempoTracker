/*
 *  PreciseOnsetLocator.h
 *  peakOnsetDetector
 *
 *  Created by Andrew on 21/09/2012.
 *  Copyright 2012 QMUL. All rights reserved.
 *
 */


#ifndef PRECISE_ONSET_LOCATOR
#define PRECISE_ONSET_LOCATOR

#include <vector.h>

class PreciseOnsetLocator{
	public:
	
	PreciseOnsetLocator();
	~PreciseOnsetLocator();
	
	int bufferSize;
	
	vector <double> onsetSamples;//holds the audio samples when onset is found
	vector <double> recentBufferSamples;
	
	double getLastEnergySum(const int& startIndex, const int& vectorSize);
	int findExactOnset(double* frame);

	int exactOnsetIndex;
	
	void setup(const int& size);
	void storeSamples(double* newSamples);
		
};
#endif