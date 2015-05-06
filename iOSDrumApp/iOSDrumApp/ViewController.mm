//
//  ViewController.m
//  iOSDrumApp
//
//  Created by Adam Stark on 07/09/2012.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "ViewController.h"
#import "AppDelegate.h"
#import <math.h>




//int onsetGenerator = 0;

@interface ViewController ()

@end

@implementation ViewController
@synthesize tempoDisplay;
@synthesize beatFlashButton;
@synthesize modeButton;
@synthesize volumeSlider;
@synthesize earlyLateSlider;


// ------------------------------------------------------------------------
// checkForBeat: checks whether the beat tracker has indicated that a beat has happened
// recently and if it has, various UI actions are performed
- (void)checkForBeat
{
    AppDelegate *appDelegate = (AppDelegate *)[[UIApplication sharedApplication] delegate];
    
    if (appDelegate->onsetEvent == YES)
    {
        appDelegate->onsetEvent = NO;
        
        earlyLateSlider.value = appDelegate->sliderVal;
        pos = (1-appDelegate->sliderVal)*3.14159265359;
    }
    
    // if beat tracker has indicated that a beat has happened
    // that hasn't been dealt with yet
    if ((appDelegate->beat == YES) && (metronomeActive == NO))
    {
        BOOL headsetPresent = [self isHeadsetPluggedIn];
                
        appDelegate->beat = NO;  // turn off the beat flag
        
        // create a string version of the tempo
        NSString *tempoString = [NSString stringWithFormat:@"%0.1f",round(10.0f * appDelegate->b->est_tempo) / 10.f];
        
        // update the tempo display on screen
        tempoDisplay.text = tempoString;
        
        // flash the beat indicator button
        [self beatFlashOn];
        
        if (headsetPresent)
        {
            [audioPlayer play];
        }
        
        
        // if tempo track mode has been set to NO
        // but metronome is not yet active then we must 
        // activate it
        if (tempoTrackMode == NO)
        {
            // Use audio services to play the sound 
            // as this is the first tick of the metronome
            //AudioServicesPlaySystemSound(soundID); 
            [audioPlayer play];
            
            // indicate that the metronome is active
            metronomeActive = YES;
            
            // if tempo value is sensible, start a timer based upon that interval
            if (appDelegate->b->est_tempo != 0)
            {
                metronome = [NSTimer scheduledTimerWithTimeInterval:(60./appDelegate->b->est_tempo)
                                                 target:self
                                               selector:@selector(metronomeTick)
                                               userInfo:nil
                                                repeats:YES]; 
            }
            
        }
    }
}

- (BOOL)isHeadsetPluggedIn {
    UInt32 routeSize = sizeof (CFStringRef);
    CFStringRef route;
    
    OSStatus error = AudioSessionGetProperty (kAudioSessionProperty_AudioRoute,
                                              &routeSize,
                                              &route);
    
    /* Known values of route:
     * "Headset"
     * "Headphone"
     * "Speaker"
     * "SpeakerAndMicrophone"
     * "HeadphonesAndMicrophone"
     * "HeadsetInOut"
     * "ReceiverAndMicrophone"
     * "Lineout"
     */
    
    if (!error && (route != NULL)) {
        
        NSString* routeStr = (__bridge NSString*)route;
        
        NSRange headphoneRange = [routeStr rangeOfString : @"Head"];
                
        if (headphoneRange.location != NSNotFound) return YES;
        
        
    }
        
    return NO;
}


// ------------------------------------------------------------------------
// metronomeTick: called whenever the metronome is active and a 'tick' occurs
- (void)metronomeTick {
    
    // flash the beat indicator button
    [self beatFlashOn];
    
    if (tempoTrackMode == YES)
    {
        [metronome invalidate];
        metronome = nil;
        metronomeActive = NO;
    }
    else {
        //Use audio services to play the sound
        //AudioServicesPlaySystemSound(soundID); 
        [audioPlayer play];
    }
}

// ------------------------------------------------------------------------
// beatFlashOn: sets the image of the button that indicates a beat has happened to the
// on state. A timer is then set to turn it off again after 100ms
- (void)beatFlashOn {
    //adamSwitch.on = !adamSwitch.on;
    
    if (beatIndicatorState == YES)
    {
        [beatFlashButton setImage:[UIImage imageNamed:@"blinkOn.png"]forState:UIControlStateNormal];
        beatIndicatorState = NO;
    }
    else 
    {
        [beatFlashButton setImage:[UIImage imageNamed:@"blinkOff.png"]forState:UIControlStateNormal];
        beatIndicatorState = YES;
    }
    
    /*
    [NSTimer scheduledTimerWithTimeInterval:1./20.
                                     target:self
                                   selector:@selector(beatFlashOff)
                                   userInfo:nil
                                    repeats:NO];
     */
}


// ------------------------------------------------------------------------
// beatFlashOff: sets the image of the beat indicator to the off state
- (void)beatFlashOff {
    [beatFlashButton setImage:[UIImage imageNamed:@"flashOff.png"]forState:UIControlStateNormal];
}

// ------------------------------------------------------------------------
// modeButtonPressed: responds to user presses of the mode button which
// sets the app either to being a tempo tracker or a metronome
- (IBAction)modeButtonPressed:(id)sender {
    
    // if we are currently in tempo track mode
    if (tempoTrackMode == YES)
    {
        // switch out of tempo track mode
        tempoTrackMode = NO;
        
        // set button text to "Metronome"
        //[modeButton setTitle:@"Metronome" forState:UIControlStateNormal];
        [modeButton setImage:[UIImage imageNamed:@"metronome_button.png"]forState:UIControlStateNormal];
    }
    else // if we are currently in metronome mode
    {
        // switch out of metronome mode
        tempoTrackMode = YES;
        
        // update button text to "Tempo Tracker"
        //[modeButton setTitle:@"Tempo Tracker" forState:UIControlStateNormal];
        
        [modeButton setImage:[UIImage imageNamed:@"tempoTracker_button.png"]forState:UIControlStateNormal];
    }
    
}

// ------------------------------------------------------------------------
// sliderValueChanged: called when the volume slider is moved
- (IBAction)sliderValueChanged:(id)sender {
    
    // if we have an audioPlayer object
    if (audioPlayer != nil)
    {
        // set its volume to the slider value
        audioPlayer.volume = volumeSlider.value;
    }
}

- (IBAction)aboutButtonPressed:(id)sender {
    [beatCheckTimer invalidate];
    beatCheckTimer = nil;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view, typically from a nib.
    
    
    /////////// GLKIT /////////
    
    EAGLContext *aContext = [[EAGLContext alloc] initWithAPI:kEAGLRenderingAPIOpenGLES2];
    
    GLKView *glkView = (GLKView *)self.view;
    glkView.delegate = self;
    glkView.context = aContext;
    
    glkView.drawableColorFormat = GLKViewDrawableColorFormatRGBA8888;
    glkView.drawableDepthFormat = GLKViewDrawableDepthFormat16;
    glkView.drawableMultisample = GLKViewDrawableMultisample4X;
    
    self.delegate = self;
    self.preferredFramesPerSecond = 30;
    
    effect = [[GLKBaseEffect alloc] init];
    
    glClearColor(0.0f, 0.0f, 0.0f, 1.0f);
    
    
    pos = 0.5;
    direction = -1;
    
    // turn on flags for displaying images
    glEnable(GL_TEXTURE_2D);
    glEnable(GL_BLEND);
    glBlendFunc(GL_ONE, GL_SRC_COLOR);
    
    GLuint      texture[1];
    glGenTextures(1, &texture[0]);
    
    glBindTexture(GL_TEXTURE_2D, texture[0]);
    
    glTexParameteri(GL_TEXTURE_2D,GL_TEXTURE_MIN_FILTER,GL_LINEAR);
    glTexParameteri(GL_TEXTURE_2D,GL_TEXTURE_MAG_FILTER,GL_LINEAR);
    
    ////////////////////////////
    
    
    // start timer to poll constantly to check for
    // beats occurring 
    beatCheckTimer = [NSTimer scheduledTimerWithTimeInterval:1./120.
                                     target:self
                                   selector:@selector(checkForBeat)
                                   userInfo:nil
                                    repeats:YES];
        

    
    tempoTrackMode = YES;
    metronomeActive = NO;
    
    
    /////////////////////////////////////////////////////////////////
    /////////////// Set Up Audio File Playback //////////////////////
  
    NSURL *url = [NSURL fileURLWithPath:[[NSBundle mainBundle]
                                         pathForResource:@"cowbell"
                                         ofType:@"wav"]];

    NSError *error;
    audioPlayer = [[AVAudioPlayer alloc]
                   initWithContentsOfURL:url
                   error:&error];
    if (error)
    {
        NSLog(@"Error in audioPlayer: %@", 
              [error localizedDescription]);
    } else {
        audioPlayer.delegate = self;
        [audioPlayer prepareToPlay];
    }
    
    if (audioPlayer != nil)
    {
        audioPlayer.volume = 0.5;
    }
    
    /////////////////////////////////////////////////////////////////
    /////////////////////////////////////////////////////////////////
    
    beatIndicatorState = YES;
    
    

    UIImage *sliderMinimum = [[UIImage imageNamed:@"volume_track.png"] stretchableImageWithLeftCapWidth:4 topCapHeight:0];
    [volumeSlider setMinimumTrackImage:sliderMinimum forState:UIControlStateNormal];
    UIImage *sliderMaximum = [[UIImage imageNamed:@"volume_track.png"] stretchableImageWithLeftCapWidth:4 topCapHeight:0];
    [volumeSlider setMaximumTrackImage:sliderMaximum forState:UIControlStateNormal];
}




- (void)viewDidUnload
{
    
    NSLog(@"Killing stuff");
    [self setTempoDisplay:nil];
    [self setBeatFlashButton:nil];
    [self setModeButton:nil];
    [self setVolumeSlider:nil];
    [self setEarlyLateSlider:nil];
    
    [beatCheckTimer invalidate];
    beatCheckTimer = nil;
    
    [self setAboutButton:nil];
    [super viewDidUnload];
    // Release any retained subviews of the main view.
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    return (interfaceOrientation != UIInterfaceOrientationPortraitUpsideDown);
}


- (void)glkViewControllerUpdate:(GLKViewController *)controller
{
    
}

- (void)glkView:(GLKView *)view drawInRect:(CGRect)rect
{
    [effect prepareToDraw];
    
    glClearColor(0.0, 0.0, 0.0, 0.0);
    glClear(GL_COLOR_BUFFER_BIT);
    

    //UIImage* image = [UIImage imageNamed:@"play.png"];
    
    /////////////////////////////////

    
    /////////////////////////////////
    


    //// Screen Info
    CGRect screenBounds = [[UIScreen mainScreen] bounds];
    CGFloat screenScale = [[UIScreen mainScreen] scale];
    CGSize screenSize = CGSizeMake(screenBounds.size.width * screenScale, screenBounds.size.height * screenScale);
    
    
    //cout << screenSize.width << endl;
    //NSLog(screenSize.width)
    
    
    //GLfloat width = 0.9;
    //GLfloat pos = ((float)(random()%100))/100.;
    
    GLfloat pi = 3.14159265359;
    
    
    if (pos > pi)
    {
        direction = -1;
    }
    
    if (pos < 0)
    {
        direction = 1;
    }
    
    //pos = pos + (direction*0.05);
    
    GLfloat x_pos = 0.6*cos(pos);
    GLfloat y_pos = 0.6*sin(pos);
    
    GLfloat baseX = 0.0;
    GLfloat baseY = 0.0;
    
    
    y_pos *= (screenSize.width/screenSize.height);
    
    
    const GLfloat line[] = {
        baseX,baseY,1,
        x_pos,y_pos,1
    };
  
    
    static const GLubyte lineColors[] = {
        255, 255,   255, 255,
        255,   255, 255, 255,
    };
    
    

    
    // enables the ability to change positional information
    glEnableVertexAttribArray(GLKVertexAttribPosition);
    glEnableVertexAttribArray(GLKVertexAttribColor);

    glVertexAttribPointer(GLKVertexAttribPosition, 3, GL_FLOAT, GL_FALSE, 0, line);
    glVertexAttribPointer(GLKVertexAttribColor, 2, GL_UNSIGNED_BYTE, GL_TRUE, 0, lineColors);
    
    glLineWidth(3);
    glDrawArrays(GL_LINES, 0, 2);

    glDisableVertexAttribArray(GLKVertexAttribPosition);
    glDisableVertexAttribArray(GLKVertexAttribColor);    
}


////////////////// AUDIO PLAYER METHODS - DON'T NEED TO IMPLEMENT //////////////

-(void)audioPlayerDidFinishPlaying:
(AVAudioPlayer *)player successfully:(BOOL)flag
{
}
-(void)audioPlayerDecodeErrorDidOccur:
(AVAudioPlayer *)player error:(NSError *)error
{
}
-(void)audioPlayerBeginInterruption:(AVAudioPlayer *)player
{
}
-(void)audioPlayerEndInterruption:(AVAudioPlayer *)player
{
}






@end





