/*
 *  PeakProcessor.cpp
 *  peakOnsetDetector
 *
 *  Created by Andrew on 07/09/2012.
 *  Copyright 2012 QMUL. All rights reserved.
 *
 */

#include "PeakProcessor.h"
#include "math.h"

PeakProcessor::PeakProcessor(){
	
	recentDFsamples.assign(vectorSize, 0.0);
	recentDFonsetFound.assign(vectorSize, false);
	recentDFslopeValues.assign(vectorSize, 0.0);
	
	numberOfDetectionValuesToTest = 10;
	currentFrame = 0;
	cutoffForRepeatOnsetsFrames = 4;
	detectionTriggerRatio = 0.5f;
	detectionTriggerThreshold = 0.1;
	bestSlopeMedian = 1;
	thresholdRelativeToMedian = 1.1;
	slopeFallenBelowMedian = true;
	lastSlopeOnsetFrame = 0;
}

PeakProcessor::~PeakProcessor(){
	
	recentDFsamples.clear();
	recentDFonsetFound.clear();
	recentDFslopeValues.clear();
}


bool PeakProcessor::peakProcessing(const double& newDFval){
	recentDFsamples.erase (recentDFsamples.begin(), recentDFsamples.begin()+1);//erase first val
	recentDFsamples.push_back(newDFval);
	
	double slopeVal = getBestSlopeValue(newDFval);
	
	newOnsetFound = checkForSlopeOnset(slopeVal);

	
	/*printf("slope %f median %f det median %f\n", slopeVal, bestSlopeMedian, detectionTriggerThreshold);
	if (newOnsetFound){
		printf("BANG!\n");
		
	}*/
	
	recentDFslopeValues.erase (recentDFslopeValues.begin(), recentDFslopeValues.begin()+1);//erase first val
	recentDFslopeValues.push_back(slopeVal);
	
	recentDFonsetFound.erase (recentDFonsetFound.begin(), recentDFonsetFound.begin()+1);//erase first val
	recentDFonsetFound.push_back(newOnsetFound);
	
	
	//printf("\n");
	//	for (int i = 0;i < recentDFsamples.size();i++){
	//		printf("rdf[%i] %f\n", i, recentDFsamples[i]);
	//	}
	//printf("SLOPE %f\n", slopeVal);
	
	return newOnsetFound;
}


double PeakProcessor::getBestSlopeValue(const float& dfvalue){
	
	//the idea is we want a high slope
	double bestValue = 0;
	
	for (int i = 1;i < min(numberOfDetectionValuesToTest, (int)recentDFsamples.size() - 1);i++){
		double angle = 0;
		int otherIndex = recentDFsamples.size() - i + 1;
		double testValue = 0;
		
		if (otherIndex > 0 && recentDFsamples[otherIndex] > 0 
			&& recentDFsamples[otherIndex] < dfvalue
			){
			angle = atan((float)(i * dfvalue)/ (numberOfDetectionValuesToTest*(dfvalue-recentDFsamples[otherIndex])) );
			testValue = (dfvalue - recentDFsamples[otherIndex]) * cos(angle);
		}
		
		if (testValue > bestValue)
			bestValue = testValue;
	}
	
	return bestValue;
	
}



bool PeakProcessor :: checkForSlopeOnset(const float& bestValue){
	bool onsetDetected = false;
	//check for onset relative to our processed slope function
	//a mix between increase in value and the gradient of that increase
	
	currentFrame++;
	
	if (bestValue > bestSlopeMedian * thresholdRelativeToMedian && //better than recent average 
		(currentFrame - lastSlopeOnsetFrame) > cutoffForRepeatOnsetsFrames //after cutoff time
		&& slopeFallenBelowMedian // has had onset and fall away again
		&& bestValue > detectionTriggerThreshold * detectionTriggerRatio //longer term ratio of winning onsets 
		){
		//	printf("frame diff between onsets %6.1f", (1000*framesToSeconds(currentFrame - lastMedianOnsetFrame)) );
		onsetDetected = true;
		lastSlopeOnsetFrame = currentFrame;
		slopeFallenBelowMedian = false;
		
		updateDetectionTriggerThreshold(bestValue);
	}
	
	
	if (bestValue > bestSlopeMedian){
		bestSlopeMedian += (bestValue - bestSlopeMedian)*0.04;//was 1.1
	}
	else{
		bestSlopeMedian *= 0.99;
		slopeFallenBelowMedian = true;;
	}
	
	//bestSlopeMedian += 0.02* (bestValue - bestSlopeMedian);
	
	return onsetDetected;
}

void PeakProcessor :: updateDetectionTriggerThreshold(const float& val){
	float detectionAdaptSpeed = 0.05;//moving average, roughly last twenty onsets
	detectionTriggerThreshold *= 1- detectionAdaptSpeed;
	detectionTriggerThreshold += (val * detectionAdaptSpeed);
}
