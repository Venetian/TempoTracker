#define BOOST_TEST_DYN_LINK
#define BOOST_TEST_MODULE BTrackPlus
#include <boost/test/unit_test.hpp>
#include <iostream>
using namespace std;
#define private public
#include "BTrackPlus.h"

//////////////////////////////////////////////////////////
//////////////////// INITIALISATION //////////////////////
//////////////////////////////////////////////////////////

BOOST_AUTO_TEST_SUITE(initialise)

BOOST_AUTO_TEST_CASE(initialise_512)
{
    // create new BTrackPlus instance
    BTrackPlus b;
    
    // initialise with hop size of 512
    b.initialise(512);
    
    
    // check that the framesize is initialised
    BOOST_CHECK_EQUAL(b.framesize,512);
    
    // check that the df buffer size is 512
    BOOST_CHECK_EQUAL(b.dfbuffer_size,512);
    
    // check that the beat period has a sensible value (80-160bpm)
    BOOST_CHECK((b.bperiod > 32) && (b.bperiod < 65));

}

BOOST_AUTO_TEST_CASE(initialise_1024)
{
    // create new BTrackPlus instance
    BTrackPlus b;
    
    // initialise with hop size of 1024
    b.initialise(1024);
    
    
    // check that the framesize is initialised
    BOOST_CHECK_EQUAL(b.framesize,1024);
    
    // check that the df buffer size is 256
    BOOST_CHECK_EQUAL(b.dfbuffer_size,256);
    
    // check that the beat period has a sensible value (80-160bpm)
    BOOST_CHECK((b.bperiod > 16) && (b.bperiod < 33));
    
}

BOOST_AUTO_TEST_SUITE_END()



//////////////////////////////////////////////////////////
//////////////////////// PROCESS /////////////////////////
//////////////////////////////////////////////////////////


BOOST_AUTO_TEST_SUITE(process)


// --------------------------------------------------------------------
// process random values, check that beats are output
// --------------------------------------------------------------------
BOOST_AUTO_TEST_CASE(process_random)
{
    // create new BTrackPlus instance
    BTrackPlus b;
    
    // initialise with hop size of 512
    b.initialise(512);
    
    // create a detection function sample
    float df_sample;
    
    // prepare to count samples since last beat
    int samples_since_beat = 0;
    
    // for 50,000 samples
    for (int i = 0;i < 50000;i++)
    {
        // create a random sample
        df_sample = random() % 500;
        
        // process the sample
        b.process(df_sample);
        
        // if playbeat occurs, reset counter
        if (b.playbeat == 1)
        {
            samples_since_beat = 0;
        }
        else
        {
            samples_since_beat++;
        }
    }
    
    // check that a beat has occurred in the last 1 second
    BOOST_CHECK(samples_since_beat < 87);
    
}

// --------------------------------------------------------------------
// process zeros for 50,000 samples, check that beats are output
// --------------------------------------------------------------------
BOOST_AUTO_TEST_CASE(process_zeros)
{
    // create new BTrackPlus instance
    BTrackPlus b;
    
    // initialise with hop size of 512
    b.initialise(512);
    
    // create a detection function sample
    float df_sample;
    
    // prepare to count samples since last beat
    int samples_since_beat = 0;
    
    // for 50,000 samples
    for (int i = 0;i < 50000;i++)
    {
        // create a sample with a value of zero
        df_sample = 0.0;

        // process the sample
        b.process(df_sample);
        
        // if playbeat occurs, reset counter
        if (b.playbeat == 1)
        {
            samples_since_beat = 0;
        }
        else
        {
            samples_since_beat++;
        }
    }
    
    // check that a beat has occurred in the last 1 second
    BOOST_CHECK(samples_since_beat < 87);
    
}


// --------------------------------------------------------------------
// process negative numbers for 50,000 samples, check that beats are output
// --------------------------------------------------------------------
BOOST_AUTO_TEST_CASE(process_all_negative)
{
    // create new BTrackPlus instance
    BTrackPlus b;
    
    // initialise with hop size of 512
    b.initialise(512);
    
    // create a detection function sample
    float df_sample;
    
    // prepare to count samples since last beat
    int samples_since_beat = 0;
    
    // for 50,000 samples
    for (int i = 0;i < 50000;i++)
    {
        // create a random negative sample
        df_sample = -1 * (random() % 500);
        
        // process the sample
        b.process(df_sample);
        
        // if playbeat occurs, reset counter
        if (b.playbeat == 1)
        {
            samples_since_beat = 0;
        }
        else
        {
            samples_since_beat++;
        }
    }
    
    // check that a beat has occurred in the last 1 second
    BOOST_CHECK(samples_since_beat < 87);
    
}


// --------------------------------------------------------------------
// process occasional negative numbers for 50,000 samples, check that beats are output
// --------------------------------------------------------------------
BOOST_AUTO_TEST_CASE(process_some_negative)
{
    // create new BTrackPlus instance
    BTrackPlus b;
    
    // initialise with hop size of 512
    b.initialise(512);
    
    // create a detection function sample
    float df_sample;
    
    // prepare to count samples since last beat
    int samples_since_beat = 0;
    
    // for 50,000 samples
    for (int i = 0;i < 50000;i++)
    {
        // create a sample with a value in the range [-250,250]
        df_sample = (random() % 500)-250;
        
        // process the sample
        b.process(df_sample);
        
        // if playbeat occurs, reset counter
        if (b.playbeat == 1)
        {
            samples_since_beat = 0;
        }
        else
        {
            samples_since_beat++;
        }
    }
    
    // check that a beat has occurred in the last 1 second
    BOOST_CHECK(samples_since_beat < 87);
    
}

BOOST_AUTO_TEST_SUITE_END()



// --------------------------------------------------------------------
// process delta function for 50,000 samples, check that beats are accurate
// --------------------------------------------------------------------
BOOST_AUTO_TEST_CASE(process_delta)
{
    // create new BTrackPlus instance
    BTrackPlus b;
    
    // initialise with hop size of 512
    b.initialise(512);
    
    // create a detection function sample
    float df_sample;
    
    // clock to generate beats 
    int time_until_beat = 50;
    
    int num_accurate_beats = 0;
    int num_beats = 0;
    
    // for 50,000 samples
    for (int i = 0;i < 50000;i++)
    {
        if (time_until_beat == 0)
        {
            // detection function sample = 1
            df_sample = 100;
            
            time_until_beat = 50;
        }
        else
        {
            // detection function sample = 0
            df_sample = 1;
            
            time_until_beat--;
        }
        
        // process the sample
        b.process(df_sample);
        
        
        if (time_until_beat == 50)
        {
            num_beats++;
            if (b.playbeat == 1)
            {
                num_accurate_beats++;
            }
        }
        
    }
    
    float perc = ((float)num_accurate_beats)/((float)num_beats);
    

    // check that algorithm gets 95%+ on this function and strict criteria
    BOOST_CHECK(perc > 0.95);
    
}


//////////////////////////////////////////////////////////
//////////////////////////////////////////////////////////
//////////////////////////////////////////////////////////