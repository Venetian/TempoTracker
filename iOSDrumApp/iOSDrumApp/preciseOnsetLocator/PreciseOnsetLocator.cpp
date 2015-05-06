/*
 *  PreciseOnsetLocator.cpp
 *  peakOnsetDetector
 *
 *  Created by Andrew on 21/09/2012.
 *  Copyright 2012 QMUL. All rights reserved.
 *
 */

#include "PreciseOnsetLocator.h"

PreciseOnsetLocator::PreciseOnsetLocator(){
	setup(512);
}

PreciseOnsetLocator::~PreciseOnsetLocator(){
	onsetSamples.clear();
	recentBufferSamples.clear();
}


void PreciseOnsetLocator::setup(const int& size){
	onsetSamples.clear();
	recentBufferSamples.clear();
	bufferSize = size;
	onsetSamples.assign(bufferSize, 0.0);
	recentBufferSamples.assign(bufferSize, 0.0);
}

void PreciseOnsetLocator::storeSamples(double* newSamples){
	
	for (int i = 0;i < bufferSize;i++)
		recentBufferSamples[i] = newSamples[i];
	
}

int PreciseOnsetLocator::findExactOnset(double* frame){
	//store the samples - mainly for viewing actually
	onsetSamples.clear();
	for (int i = 0; i < bufferSize;i++) {
		onsetSamples.push_back(frame[i]);
	}
	
	double energySum = 0;
	double lastEnergySum, hopsizeLastEnergySum;
	double energyDifference;
	int bestEnergyIndex = 0;
	double bestEnergyDifference = 0;
	int endIndex = bufferSize;
	int hopSize;
	
	for (int resolution = bufferSize/2;resolution > 1;resolution/=2){
		//printf("resolution %i\n", resolution);
		
		bestEnergyDifference = 0;
		//	printf("previous energy %f", lastEnergySum);
		//initialise last energySum
		hopSize = resolution/2;
		
		
		lastEnergySum = getLastEnergySum(bestEnergyIndex, resolution);
		hopsizeLastEnergySum = getLastEnergySum(bestEnergyIndex + hopSize, resolution);
		
		for (int startIndex = bestEnergyIndex;startIndex + resolution <= endIndex;startIndex += hopSize){
			//printf("index %i last energy %f hop energy %f ", startIndex, lastEnergySum, hopsizeLastEnergySum);
			
			//sum the energy for this new frame
			energySum = 0;
			for (int i = 0;i < resolution;i++){
				energySum += onsetSamples[startIndex + i] * onsetSamples[startIndex + i];
			}
			
			//printf("energysum %f\n", energySum);
			//check if new max difference
			energyDifference = energySum - lastEnergySum;
			if (energyDifference > bestEnergyDifference){
				bestEnergyDifference = energyDifference;
				bestEnergyIndex = startIndex;
			}
			
			//store the values for checking in two loops time (because proceeding at resolution/2 each step)
			//eg 0_to_128 compared to -128_to_0, 64_to_196 compared to -64_to_64, then 128_256 compared with 0_to_128, 
			lastEnergySum = hopsizeLastEnergySum;// energySum;
			hopsizeLastEnergySum = energySum;
			
		}
		//printf("winning index is %i\n", bestEnergyIndex);
		endIndex = bestEnergyIndex + resolution;
		
	}
	//printf("TOTAL WINNER %i\n", bestEnergyIndex);
	return bestEnergyIndex;
	
}

double PreciseOnsetLocator::getLastEnergySum(const int& startIndex, const int& vectorSize){
	double lastEnergySum = 0;
	
	for (int i = startIndex - vectorSize;i < startIndex;i++){
		if (i > 0)
			lastEnergySum += onsetSamples[i] * onsetSamples[i];
		else {
			lastEnergySum += recentBufferSamples[bufferSize + i] * recentBufferSamples[bufferSize + i];
		}
	}
	return lastEnergySum;
	
}
