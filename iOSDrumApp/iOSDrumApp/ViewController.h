//
//  ViewController.h
//  iOSDrumApp
//
//  Created by Adam Stark on 07/09/2012.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <GLKit/GLKit.h>
#import <AVFoundation/AVFoundation.h>

// for audio file playback
//SystemSoundID soundID;

BOOL tempoTrackMode;
BOOL metronomeActive;
BOOL beatIndicatorState;
NSTimer *metronome;

//@class AppDelegate;


//@interface ViewController : UIViewController <AVAudioPlayerDelegate> {
@interface ViewController : GLKViewController <GLKViewControllerDelegate, GLKViewDelegate, AVAudioPlayerDelegate> {
    
    AVAudioPlayer *audioPlayer;
    
    NSTimer *beatCheckTimer;
    
@private
    GLKBaseEffect *effect;
    GLfloat pos,direction;
    GLuint spriteTexture;
}

@property (weak, nonatomic) IBOutlet UILabel *tempoDisplay;
@property (weak, nonatomic) IBOutlet UIButton *beatFlashButton;
@property (weak, nonatomic) IBOutlet UIButton *modeButton;
@property (weak, nonatomic) IBOutlet UISlider *volumeSlider;
@property (weak, nonatomic) IBOutlet UISlider *earlyLateSlider;
@property (weak, nonatomic) IBOutlet UIButton *aboutButton;

- (void)checkForBeat;
- (void)beatFlashOn;
- (void)beatFlashOff;
- (IBAction)modeButtonPressed:(id)sender;
- (IBAction)sliderValueChanged:(id)sender;
- (IBAction)aboutButtonPressed:(id)sender;

- (void)metronomeTick;

- (BOOL)isHeadsetPluggedIn;




#pragma mark GLKViewControllerDelegate
- (void)glkViewControllerUpdate:(GLKViewController *)controller;

#pragma mark GLKViewDelegate
- (void)glkView:(GLKView *)view drawInRect:(CGRect)rect;

@end



