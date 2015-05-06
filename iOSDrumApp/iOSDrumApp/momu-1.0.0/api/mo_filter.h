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
// name: mo_filter.h
// desc: MoPhO API for common digital filters (based on STK's Filter class)
//
// authors: Ge Wang (ge@ccrma.stanford.edu)
//          Nick Bryan
//          Jieun Oh
//          Jorge Hererra
//
//    date: Fall 2009
//    version: 1.0.0
//
// Stanford Mobile Phone Orchestra
//     http://mopho.stanford.edu/
//-----------------------------------------------------------------------------
//-----------------------------------------------------------------------------
/* class Filter
   brief ATK abstract filter class.
 
   This class provides limited common functionality for STK digital
   filter subclasses.  It is general enough to support both
   monophonic and polyphonic input/output classes.
 
   by Perry R. Cook and Gary P. Scavone, 1995 - 2009. */
//-----------------------------------------------------------------------------
#ifndef __MO_FILTER_H__
#define __MO_FILTER_H__

#include "mo_def.h"




//-----------------------------------------------------------------------------
// name: class MoFilter
// desc: general filter class
//-----------------------------------------------------------------------------
class MoFilter
{
public:
    // constructor.
    MoFilter() { m_gain = 1.0; m_lastValue = 0.0; m_nB = 0; m_nA = 0; 
                 m_b = NULL; m_a = NULL; 
                 m_outputs = NULL; m_inputs = NULL; }
    virtual ~MoFilter();
    
    // clears all internal states of the filter.
    virtual void clear( void );
    
    // set filter coefficients
    // an StkError can be thrown if either \e nb or \e na is less than
    // one, or if the a[0] coefficient is equal to zero.  If a[0] is not
    // equal to 1, the filter coeffcients are normalized by a[0]
    void setCoefficients( long nb, SAMPLE * bCoefficients, 
                          long na, SAMPLE * aCoefficients );
    
    // set the filter gain...
    // the gain is applied at the filter input and does not affect the
    // coefficient values.  The default gain value is 1.0.
    void setGain( SAMPLE gain ) { m_gain = gain; }
    
    // return the current filter gain.
    SAMPLE getGain( void ) const { return m_gain; }

    // return the last computed output value
    SAMPLE lastOut( void ) const { return m_lastValue; }

protected:
    SAMPLE m_gain;
    long m_nB;
    long m_nA;
    SAMPLE * m_b;
    SAMPLE * m_a;
    SAMPLE * m_outputs;
    SAMPLE * m_inputs;
    SAMPLE m_lastValue;
};




//-----------------------------------------------------------------------------
// name: class MoOneZero()
// desc: ...
//-----------------------------------------------------------------------------
class MoOneZero : public MoFilter
{        
public:
    // the default constructor creates a low-pass filter (zero at z = -1.0)
    MoOneZero( SAMPLE theZero = -1.0 );
    // destructor
    ~MoOneZero();
    
    // set the b[0] coefficient value
    void setB0( SAMPLE b0 ) { m_b[0] = b0; }    
    // set the b[1] coefficient value
    void setB1( SAMPLE b1 ) { m_b[1] = b1; }
    // set all filter coefficients.
    void setCoefficients( SAMPLE b0, SAMPLE b1, bool clearState = false );
    
    // set the zero position in the z-plane
    // this method sets the zero position along the real-axis of the
    // z-plane and normalizes the coefficients for a maximum gain of one.
    // a positive zero value produces a high-pass filter, while a
    // negative zero value produces a low-pass filter.  This method does
    // not affect the filter gain value.    
    void setZero( SAMPLE theZero );

    // input one sample to the filter and return one output
    SAMPLE tick( SAMPLE input );
};




//-----------------------------------------------------------------------------
// name: class MoOnePole
// desc: ...
//-----------------------------------------------------------------------------
class MoOnePole : public MoFilter
{
public:
    // the default constructor creates a low-pass filter (pole at z = 0.9)
    MoOnePole( SAMPLE thePole = 0.9 );
    // destructor
    ~MoOnePole();

    // set the b[0] coefficient value
    void setB0( SAMPLE b0 ) { m_b[0] = b0; }
    // set the a[1] coefficient value
    void setA1( SAMPLE a1 ) { m_a[1] = a1; }    
    // set all filter coefficients
    void setCoefficients( SAMPLE b0, SAMPLE a1, bool clearState = false );
    
    // set the pole position in the z-plane
    // this method sets the pole position along the real-axis of the
    // z-plane and normalizes the coefficients for a maximum gain of one.
    // a positive pole value produces a low-pass filter, while a negative
    // pole value produces a high-pass filter.  This method does not
    // affect the filter gain value.
    void setPole( SAMPLE thePole );
    
    // input one sample to the filter and return one output
    SAMPLE tick( SAMPLE input );
};




//-----------------------------------------------------------------------------
// name: class MoPoleZero
// desc: ...
//-----------------------------------------------------------------------------
class MoPoleZero : public MoFilter
{
public:
    // default constructor creates a first-order pass-through filter.
    MoPoleZero();
    // class destructor.
    ~MoPoleZero();

    // set the b[0] coefficient value
    void setB0( SAMPLE b0 ) { m_b[0] = b0; }
    // set the b[1] coefficient value
    void setB1( SAMPLE b1 ) { m_b[1] = b1; }
    // set the a[1] coefficient value.
    void setA1( SAMPLE a1 ) { m_a[1] = a1; }
    
    // set all filter coefficients
    void setCoefficients( SAMPLE b0, SAMPLE b1, SAMPLE a1, bool clearState = false );
    
    // set the filter for allpass behavior using coefficient
    // this method uses coefficient to create an allpass filter,
    // which has unity gain at all frequencies.  Note that the
    // coefficient magnitude must be less than one to maintain stability
    void setAllpass( SAMPLE coefficient );
    
    // create a DC blocking filter with the given pole position in the z-plane    
    // this method sets the given pole position, together with a zero
    // at z=1, to create a DC blocking filter.  the pole should be
    // close to one to minimize low-frequency attenuation    
    void setBlockZero( SAMPLE thePole = 0.99 );
    
    // input one sample to the filter and return one output
    SAMPLE tick( SAMPLE input );
};




//-----------------------------------------------------------------------------
// name: class MoTwoPole
// desc: ...
//-----------------------------------------------------------------------------
class MoTwoPole : public MoFilter
{
public:
    // default constructor creates a second-order pass-through filter
    MoTwoPole();
    // destructor
    ~MoTwoPole();

    // set the b[0] coefficient value
    void setB0( SAMPLE b0 ) { m_b[0] = b0; }
    // set the a[1] coefficient value
    void setA1( SAMPLE a1 ) { m_a[1] = a1; }
    // set the a[2] coefficient value
    void setA2( SAMPLE a2 ) { m_a[2] = a2; }
    
    // set all filter coefficients
    void setCoefficients( SAMPLE b0, SAMPLE a1, SAMPLE a2, bool clearState = false );
    
    // sets the filter coefficients for a resonance at frequency (in Hz)
    // this method determines the filter coefficients corresponding to
    // two complex-conjugate poles with the given \e frequency (in Hz)
    // and \e radius from the z-plane origin.  if \e normalize is true,
    // the coefficients are then normalized to produce unity gain at \e
    // frequency (the actual maximum filter gain tends to be slightly
    // greater than unity when \e radius is not close to one).  the
    // resulting filter frequency response has a resonance at the given
    // \e frequency.  The closer the poles are to the unit-circle (\e
    // radius close to one), the narrower the resulting resonance width.
    // an unstable filter will result for \e radius >= 1.0.  For a better
    // resonance filter, use a MoBiQuad filter.
    void setResonance( SAMPLE frequency, SAMPLE radius, bool normalize = false );

    // input one sample to the filter and return one output
    SAMPLE tick( SAMPLE input );
};




//-----------------------------------------------------------------------------
// name: class MoTwoZero
// desc: ...
//-----------------------------------------------------------------------------
class MoTwoZero : public MoFilter
{
public:
    // default constructor creates a second-order pass-through filter
    MoTwoZero();
    // destructor
    ~MoTwoZero();
    
    // set the b[0] coefficient value
    void setB0( SAMPLE b0 ) { m_b[0] = b0; }
    // set the b[1] coefficient value
    void setB1( SAMPLE b1 ) { m_b[1] = b1; }
    // set the b[2] coefficient value
    void setB2( SAMPLE b2 ) { m_b[2] = b2; }
    // set anti
    void setNotch( SAMPLE freq, SAMPLE radius );
    
    // set all filter coefficients
    void setCoefficients( SAMPLE b0, SAMPLE b1, SAMPLE b2, bool clearState = false );
    
    // input one sample to the filter and return one output
    SAMPLE tick( SAMPLE input );
};




//-----------------------------------------------------------------------------
// name: class MoBiQuad
// desc: ...
//-----------------------------------------------------------------------------
class MoBiQuad : public MoFilter
{
public:
    // default constructor creates a second-order pass-through filter
    MoBiQuad();
    // destructor
    ~MoBiQuad();
    
    // set all filter coefficients
    void setCoefficients( SAMPLE b0, SAMPLE b1, SAMPLE b2, 
                          SAMPLE a1, SAMPLE a2, bool clearState = false );
    
    // set the b[0] coefficient value
    void setB0( SAMPLE b0 ) { m_b[0] = b0; }    
    // set the b[1] coefficient value
    void setB1( SAMPLE b1 ) { m_b[1] = b1; }
    // set the b[2] coefficient value
    void setB2( SAMPLE b2 ) { m_b[2] = b2; }
    // set the a[1] coefficient value
    void setA1( SAMPLE a1 ) { m_a[1] = a1; }
    // set the a[2] coefficient value
    void setA2( SAMPLE a2 ) { m_a[2] = a2; }

    // sets the filter coefficients for a resonance at \e frequency (in Hz)
    // this method determines the filter coefficients corresponding to
    // two complex-conjugate poles with the given \e frequency (in Hz)
    // and \e radius from the z-plane origin.  If \e normalize is true,
    // the filter zeros are placed at z = 1, z = -1, and the coefficients
    // are then normalized to produce a constant unity peak gain
    // (independent of the filter \e gain parameter).  The resulting
    // filter frequency response has a resonance at the given \e
    // frequency.  The closer the poles are to the unit-circle (\e radius
    // close to one), the narrower the resulting resonance width.
    void setResonance( SAMPLE frequency, SAMPLE radius, bool normalize = false );
    
    // set the filter coefficients for a notch at \e frequency (in Hz)
    // this method determines the filter coefficients corresponding to
    // two complex-conjugate zeros with the given \e frequency (in Hz)
    // and \e radius from the z-plane origin.  No filter normalization
    // is attempted.
    void setNotch( SAMPLE frequency, SAMPLE radius );
    
    // sets the filter zeroes for equal resonance gain.
    // when using the filter as a resonator, zeroes places at z = 1, z
    // = -1 will result in a constant gain at resonance of 1 / (1 - R),
    // where R is the pole radius setting.
    void setEqualGainZeroes();

    
    // input one sample to the filter and return a reference to one output
    SAMPLE tick( SAMPLE input );
};




#endif
