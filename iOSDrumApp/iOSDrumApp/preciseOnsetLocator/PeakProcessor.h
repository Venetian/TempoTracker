/*
 *  PeakProcessor.h
 *  peakOnsetDetector
 *
 *  Created by Andrew on 07/09/2012.
 *  Copyright 2012 QMUL. All rights reserved.
 *
 */

#ifndef PEAK_PROCESSOR
#define PEAK_PROCESSOR

#include <vector.h>

class PeakProcessor{
	public:
	
	PeakProcessor();
	~PeakProcessor();
	//peak processing requires
	static const int vectorSize = 512/6; 
	vector<double> recentDFsamples; 
	vector<bool> recentDFonsetFound;
	vector<double> recentDFslopeValues;
	
	int numberOfDetectionValuesToTest;
	bool peakProcessing(const double& newDFval);
	double getBestSlopeValue(const float& dfvalue);
	bool checkForSlopeOnset(const float& bestValue);
	int currentFrame, lastSlopeOnsetFrame, cutoffForRepeatOnsetsFrames;
	void updateDetectionTriggerThreshold(const float& val);
	float detectionTriggerThreshold, detectionTriggerRatio;
	float bestSlopeMedian, thresholdRelativeToMedian;
	bool newOnsetFound, slopeFallenBelowMedian;
	

	
};
#endif