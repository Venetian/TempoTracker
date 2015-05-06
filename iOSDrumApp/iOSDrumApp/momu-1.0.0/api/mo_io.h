/*----------------------------------------------------------------------------
  MoMu: A Mobile Music Toolkit
  Copyright (c) 2010 Nicholas J. Bryan, Jorge Herrera, Jieun Oh, and Ge Wang
  All rights reserved.
    http://momu.stanford.edu/toolkit/
 
  Mobile Music Research @ CCRMA
  Music, Computing, Design Group
  Stanford University
    http://momu.stanford.edu/
    http://ccrma.stanford.edu/groups/mcd/
 
 MoMu is distributed under the following BSD style open source license:
 
 Permission is hereby granted, free of charge, to any person obtaining a 
 copy of this software and associated documentation files (the
 "Software"), to deal in the Software without restriction, including
 without limitation the rights to use, copy, modify, merge, publish,
 distribute, sublicense, and/or sell copies of the Software, and to
 permit persons to whom the Software is furnished to do so, subject to
 the following conditions:
 
 The authors encourage users of MoMu to include this copyright notice,
 and to let us know that you are using MoMu. Any person wishing to 
 distribute modifications to the Software is encouraged to send the 
 modifications to the original authors so that they can be incorporated 
 into the canonical version.
 
 The Software is provided "as is", WITHOUT ANY WARRANTY, express or implied,
 including but not limited to the warranties of MERCHANTABILITY, FITNESS
 FOR A PARTICULAR PURPOSE and NONINFRINGEMENT.  In no event shall the authors
 or copyright holders by liable for any claim, damages, or other liability,
 whether in an actino of a contract, tort or otherwise, arising from, out of
 or in connection with the Software or the use or other dealings in the 
 software.
 -----------------------------------------------------------------------------*/
//-----------------------------------------------------------------------------
// name: mo_io.h
// desc: MoPhO API for common input/output
//
// authors: Ge Wang (ge@ccrma.stanford.edu)
//          Nick Bryan
//          Jieun Oh
//          Jorge Hererra
//
//    date: Fall 2009
//    version: 1.0.0
//
// Mobile Music research @ CCRMA, Stanford University:
//     http://momu.stanford.edu/
//-----------------------------------------------------------------------------
//-----------------------------------------------------------------------------
/* class WvIn
   brief STK audio input abstract base class.
 
   This class provides common functionality for a variety of audio
   data input subclasses.
 
   by Perry R. Cook and Gary P. Scavone, 1995 - 2009. */
//-----------------------------------------------------------------------------
#ifndef __MO_IO_H__
#define __MO_IO_H__

#include "mo_def.h"
#include <string>


//------------------------------------------------------------------------------
// name: class MoAudioFileIn
// desc: ...
//------------------------------------------------------------------------------
class MoAudioFileIn
{
public:
    // constructor
    MoAudioFileIn();
    // destructor
    virtual ~MoAudioFileIn();
    // open the specified file and load its data
    virtual bool openFile( const char * fileName, const char * extension, bool raw = FALSE, 
                           bool doNormalize = TRUE, bool generate = true );
    // if a file is open, close it
    void closeFile();
    // clear outputs and reset time (file pointer) to zero
    void reset();
    
    // normalize data to a maximum of +-1.0
    /*
     for large, incrementally loaded files with integer data types,
     normalization is computed relative to the data type maximum.
     No normalization is performed for incrementally loaded files
     with floating-point data types. */
    void normalize();
    
    // normalize data to a maximum of \e +-peak
    /*
     for large, incrementally loaded files with integer data types,
     normalization is computed relative to the data type maximum 
     (peak/maximum).  For incrementally loaded files with floating-
     point data types, direct scaling by peak is performed. */
    void normalize( SAMPLE peak );
    
    // return the file size in sample frames
    unsigned long getSize() const;
    
    // return the number of audio channels in the file
    unsigned int getChannels() const;
    
    // return the input file sample rate in Hz (not the data read rate)
    /*
     WAV, SND, and AIF formatted files specify a sample rate in
     their headers.  STK RAW files have a sample rate of 22050 Hz
     by definition.  MAT-files are assumed to have a rate of 44100 Hz. */
    SAMPLE getFileRate() const;
    
    // query whether reading is complete
    bool isFinished() const;
    
    // set the data read rate in samples.  The rate can be negative
    void setRate( SAMPLE aRate );

    // increment the read pointer by aTime samples.
    virtual void addTime( SAMPLE aTime );

    // turn linear interpolation on/off
    /*!
     interpolation is automatically off when the read rate is
     an integer value.  If interpolation is turned off for a
     fractional rate, the time index is truncated to an integer
     value. */
    void setInterpolate( bool doInterpolate );

    // return the average across the last output sample frame
    virtual SAMPLE lastOut() const;
    // read out the average across one sample frame of data.
    virtual SAMPLE tick();
    // read out vectorSize averaged sample frames of data in vector
    virtual SAMPLE * tick( SAMPLE * vector, unsigned int vectorSize );
    // return a pointer to the last output sample frame
    virtual const SAMPLE * lastFrame() const;
    // eturn a pointer to the next sample frame of data.
    virtual const SAMPLE * tickFrame();
    // read out sample frames of data to frameVector
    virtual SAMPLE * tickFrame( SAMPLE *frameVector, unsigned int frames );

public: // SWAP formerly protected
    typedef unsigned long STK_FORMAT;
    static const STK_FORMAT STK_SINT8;  /* -128 to +127 */
    static const STK_FORMAT STK_SINT16; /* -32768 to +32767 */
    static const STK_FORMAT STK_SINT32; /* -2147483648 to +2147483647. */
    static const STK_FORMAT MY_FLOAT32; /* normalized between plus/minus 1.0. */
    static const STK_FORMAT MY_FLOAT64; /* normalized between plus/minus 1.0. */

    // initialize class variables
    void init();
    // read file data
    virtual bool readData( unsigned long index );
    // get STK RAW file information
    bool getRawInfo( const char *fileName );
    // get WAV file header information
    bool getWavInfo( const char *fileName );
    // get SND (AU) file header information
    bool getSndInfo( const char *fileName );
    // get AIFF file header information
    bool getAifInfo( const char *fileName );
    // get MAT-file header information
    bool getMatInfo( const char *fileName );

    // char msg[256];
    const char * m_filename; // chuck data
    FILE * fd;
    SAMPLE * data;
    SAMPLE * lastOutput;
    bool chunking;
    bool finished;
    bool interpolate;
    bool byteswap;
    unsigned long fileSize;
    unsigned long bufferSize;
    unsigned long dataOffset;
    unsigned int channels;
    long chunkPointer;
    STK_FORMAT dataType;
    SAMPLE fileRate;
    SAMPLE gain;
    SAMPLE time;
    SAMPLE rate;

public:
    bool m_loaded;
    SAMPLE m_gain;
};




#endif
