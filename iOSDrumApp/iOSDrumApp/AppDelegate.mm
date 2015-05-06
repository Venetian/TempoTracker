//
//  AppDelegate.m
//  iOSDrumApp
//
//  Created by Adam Stark on 07/09/2012.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "AppDelegate.h"
#import "mo_audio.h"


// ------------------------------------------------------------------------
// audioCallback: the audio processing loop
void audioCallback( Float32 * buffer, UInt32 framesize, void* userData)
{
    AppDelegate *appDelegate = (AppDelegate *)[[UIApplication sharedApplication] delegate];
    
    double inL[framesize];
    double inR[framesize];
    float df_val;
    
    // for each audio sample in the interleaved buffer
    for (int i = 0;i < framesize;i++)
    {
        // copy left and right samples to respective buffers
        inL[i] = (double) buffer[2*i];
        inR[i] = (double) buffer[2*i+1];
        
        // set output to silence
        buffer[2*i] = buffer[2*i+1] = 0.0;
    }
    
    // calculate the onset detection function sample from the input audio buffer
    df_val = (float) appDelegate->onset->getDFsample(inL) + 0.0001;
    
    
    bool peakFound = appDelegate->peakProcess->peakProcessing((double)df_val);
    
    if (peakFound)
    {
        appDelegate->onsetEvent = YES;
        
        
        float exactOnsetIndex = ((float)appDelegate->precisionLocator->findExactOnset(&inL[0])/((float) FRAMESIZE));
        
        exactOnsetIndex -= 0.5;
        
        int timeToBeat = appDelegate->b->getTimeToBeat();
        
        if (abs(timeToBeat) < 6)
        {
            float alpha = 0.6;
            appDelegate->sliderVal *= (1-alpha);
            appDelegate->sliderVal += alpha * (5.5 + exactOnsetIndex - (float)timeToBeat )/11.0;
            
        }
    }
    
    // process the onset detection function sample in the beat tracker
    appDelegate->b->process(df_val);
    
    // if there is a beat
    if (appDelegate->b->playbeat == 1)
    {
        //NSLog(@"BOOM");
        
        appDelegate->beat = YES;
        
    }
}


@implementation AppDelegate

@synthesize window = _window;




- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
    onset = new OnsetDetectionFunction(FRAMESIZE,FRAMESIZE*2,6,1);
    b = new BTrackPlus();
    peakProcess = new PeakProcessor();
    precisionLocator = new PreciseOnsetLocator();
    
    // init audio
	NSLog(@"Initializing Audio");
    
    // init the audio layer
	bool result = MoAudio::init(SRATE, FRAMESIZE, NUMCHANNELS);
    
    if (!result)
	{
		NSLog(@"cannot initialize real-time audio!");
		//return;
	}
    
    // start the audio layer, registering a callback method
	result = MoAudio::start( audioCallback, NULL);
	if (!result)
	{
		NSLog(@"cannot start real-time audio!");
		//return;
	}
    
    beat = NO;
    b->initialise((int) FRAMESIZE);	// initialise beat tracker
    precisionLocator->setup((int) FRAMESIZE);
    
    // Override point for customization after application launch.
    return YES;
}
							
- (void)applicationWillResignActive:(UIApplication *)application
{
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
}

- (void)applicationDidEnterBackground:(UIApplication *)application
{
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later. 
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
}

- (void)applicationWillEnterForeground:(UIApplication *)application
{
    // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
}

- (void)applicationDidBecomeActive:(UIApplication *)application
{
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
}

- (void)applicationWillTerminate:(UIApplication *)application
{
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
}

@end
