//
//  AppDelegate.h
//  iOSDrumApp
//
//  Created by Adam Stark on 07/09/2012.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//



#import <UIKit/UIKit.h>
#import <AudioToolbox/AudioToolbox.h>
#include "OnsetDetectionFunction.h"
#include "BTrackPlus.h"
#include "PeakProcessor.h"
#include "PreciseOnsetLocator.h"



#define SRATE 44100
#define FRAMESIZE 512
#define NUMCHANNELS 2


//@class ViewController;
void audioCallback( Float32 * buffer, UInt32 framesize, void* userData);


@interface AppDelegate : UIResponder <UIApplicationDelegate>
{
    @public
    BOOL onsetEvent;
    BOOL beat;
    Float32 sliderVal;
    PeakProcessor *peakProcess;
    PreciseOnsetLocator *precisionLocator;
    BTrackPlus *b;
    OnsetDetectionFunction *onset;
}

@property (strong, nonatomic) UIWindow *window;

@end

