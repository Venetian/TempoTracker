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
// name: mo_filter.cpp
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
// Mobile Music research @ CCRMA, Stanford University:
//     http://momu.stanford.edu/
//-----------------------------------------------------------------------------
#include "mo_filter.h"
#include "mo_audio.h"
#include <stdio.h>




//-----------------------------------------------------------------------------
// name: clear()
// desc: clear the filter
//-----------------------------------------------------------------------------
void MoFilter::clear( )
{
    long i;
    for( i = 0; i < m_nB; i++ ) m_inputs[i] = 0.0;
    for( i = 0; i < m_nA; i++ ) m_outputs[i] = 0.0;
    m_lastValue = 0.0;
}




//-----------------------------------------------------------------------------
// name: setCoefficients()
// desc: ...
//-----------------------------------------------------------------------------
void MoFilter::setCoefficients( long nb, SAMPLE * bCoefficients,
                                long na, SAMPLE * aCoefficients )
{
    long i;

    // check the arguments.
    if( nb < 1 || na < 1 )
    {
        fprintf( stderr, "[mopho](via MoFilter): nb (%d) and na (%d) must be >= 1!", nb, na );
        return;
    }
    if( aCoefficients[0] == 0.0 )
    {
        fprintf( stderr, "[mopho](via MoFilter): a[0] coefficient cannot == 0!" );
        return;
    }

    if( nb != m_nB )
    {
        delete [] m_b;
        delete [] m_inputs;
        m_nB = nb;
        m_b = new SAMPLE[m_nB];
        m_inputs = new SAMPLE[m_nB];
        for( i = 0; i < m_nB; i++ ) m_inputs[i] = 0.0;
    }

    if( na != m_nA )
    {
        delete [] m_a;
        delete [] m_outputs;
        m_nA = na;
        m_a = new SAMPLE[m_nA];
        m_outputs = new SAMPLE[m_nA];
        for( i = 0; i < m_nA; i++ ) m_outputs[i] = 0.0;
    }

    for( i = 0; i < m_nB; i++ ) m_b[i] = bCoefficients[i];
    for( i = 0; i < m_nA; i++ ) m_a[i] = aCoefficients[i];

    // scale coefficients by a[0] if necessary
    if( m_a[0] != 1.0 )
    {
        for( i = 0; i < m_nB; i++ ) m_b[i] /= m_a[0];
        for( i = 0; i < m_nA; i++ ) m_a[i] /= m_a[0];
    }
}




//-----------------------------------------------------------------------------
// name: ~MoFilter()
// desc: ...
//-----------------------------------------------------------------------------
MoFilter::~MoFilter()
{
    SAFE_DELETE_ARRAY( m_b );
    SAFE_DELETE_ARRAY( m_a );
    SAFE_DELETE_ARRAY( m_inputs );
    SAFE_DELETE_ARRAY( m_outputs );
    m_nB = 0;
    m_nA = 0;
}




//-----------------------------------------------------------------------------
// name: MoOneZero()
// desc: ...
//-----------------------------------------------------------------------------
MoOneZero :: MoOneZero( SAMPLE theZero )
{
    SAMPLE B[2];
    SAMPLE A = 1.0;
    
    // normalize coefficients for unity gain.
    if( theZero > 0.0 ) B[0] = 1.0 / ((SAMPLE) 1.0 + theZero);
    else B[0] = 1.0 / ((SAMPLE) 1.0 - theZero);    
    B[1] = -theZero * B[0];
    
    MoFilter::setCoefficients( 2, B, 1, &A );
}




//-----------------------------------------------------------------------------
// name: MoOneZero()
// desc: ...
//-----------------------------------------------------------------------------
MoOneZero :: ~MoOneZero( void )
{}




//-----------------------------------------------------------------------------
// name: setZero()
// desc: ...
//-----------------------------------------------------------------------------
void MoOneZero :: setZero( SAMPLE theZero )
{
    // normalize coefficients for unity gain.
    if ( theZero > 0.0 )
        m_b[0] = 1.0 / ((SAMPLE) 1.0 + theZero);
    else
        m_b[0] = 1.0 / ((SAMPLE) 1.0 - theZero);
    
    m_b[1] = -theZero * m_b[0];
}




//-----------------------------------------------------------------------------
// name: setCoefficients()
// desc: ...
//-----------------------------------------------------------------------------
void MoOneZero :: setCoefficients( SAMPLE b0, SAMPLE b1, bool clearState )
{
    m_b[0] = b0;
    m_b[1] = b1;

    if( clearState ) this->clear();
}




//-----------------------------------------------------------------------------
// name: tick()
// desc: ...
//-----------------------------------------------------------------------------
SAMPLE MoOneZero :: tick( SAMPLE input )
{
    m_inputs[0] = m_gain * input;
    m_lastValue = m_b[1] * m_inputs[1] + m_b[0] * m_inputs[0];
    m_inputs[1] = m_inputs[0];

    return m_lastValue;
}




//-----------------------------------------------------------------------------
// name: MoOnePole()
// desc: ...
//-----------------------------------------------------------------------------
MoOnePole :: MoOnePole( SAMPLE thePole )
{
    SAMPLE B;
    SAMPLE A[2] = {1.0, -0.9};
    
    // normalize coefficients for peak unity gain.
    if( thePole > 0.0 ) B = (SAMPLE) (1.0 - thePole);
    else B = (SAMPLE) (1.0 + thePole);

    A[1] = -thePole;

    MoFilter::setCoefficients( 1, &B, 2, A );
}




//-----------------------------------------------------------------------------
// name: ~MoOnePole()
// desc: ...
//-----------------------------------------------------------------------------
MoOnePole :: ~MoOnePole()    
{}




//-----------------------------------------------------------------------------
// name: setPole()
// desc: ...
//-----------------------------------------------------------------------------
void MoOnePole :: setPole( SAMPLE thePole )
{
    // normalize coefficients for peak unity gain.
    if( thePole > 0.0 ) m_b[0] = (SAMPLE) (1.0 - thePole);
    else m_b[0] = (SAMPLE) (1.0 + thePole);
    
    m_a[1] = -thePole;
}




//-----------------------------------------------------------------------------
// name: setCoefficients()
// desc: ...
//-----------------------------------------------------------------------------
void MoOnePole :: setCoefficients( SAMPLE b0, SAMPLE a1, bool clearState )
{
    m_b[0] = b0;
    m_a[1] = a1;

    if( clearState ) this->clear();
}




//-----------------------------------------------------------------------------
// name: tick()
// desc: ...
//-----------------------------------------------------------------------------
SAMPLE MoOnePole :: tick( SAMPLE input )
{
    m_inputs[0] = m_gain * input;
    m_lastValue = m_b[0] * m_inputs[0] - m_a[1] * m_outputs[1];
    m_outputs[1] = m_lastValue;
    
    return m_lastValue;
}




//-----------------------------------------------------------------------------
// name: MoPoleZero()
// desc: ...
//-----------------------------------------------------------------------------
MoPoleZero :: MoPoleZero()
{
    // default setting for pass-through
    SAMPLE B[2] = { 1.0, 0.0 };
    SAMPLE A[2] = { 1.0, 0.0 };

    MoFilter::setCoefficients( 2, B, 2, A );
}




//-----------------------------------------------------------------------------
// name: MoPoleZero()
// desc: ...
//-----------------------------------------------------------------------------
MoPoleZero :: ~MoPoleZero()
{}




//-----------------------------------------------------------------------------
// name: setCoefficients()
// desc: ...
//-----------------------------------------------------------------------------
void MoPoleZero :: setCoefficients( SAMPLE b0, SAMPLE b1, SAMPLE a1, bool clearState )
{
    m_b[0] = b0;
    m_b[1] = b1;
    m_a[1] = a1;

    if( clearState ) this->clear();
}




//-----------------------------------------------------------------------------
// name: setAllpass()
// desc: ...
//-----------------------------------------------------------------------------
void MoPoleZero :: setAllpass( SAMPLE coefficient )
{
    m_b[0] = coefficient;
    m_b[1] = 1.0;
    m_a[0] = 1.0; // just in case
    m_a[1] = coefficient;
}




//-----------------------------------------------------------------------------
// name: setBlockZero()
// desc: ...
//-----------------------------------------------------------------------------
void MoPoleZero :: setBlockZero( SAMPLE thePole )
{
    m_b[0] = 1.0;
    m_b[1] = -1.0;
    m_a[0] = 1.0; // just in case
    m_a[1] = -thePole;
}




//-----------------------------------------------------------------------------
// name: tick()
// desc: ...
//-----------------------------------------------------------------------------
SAMPLE MoPoleZero :: tick( SAMPLE input )
{
    m_inputs[0] = m_gain * input;
    m_lastValue = m_b[0] * m_inputs[0] + m_b[1] * m_inputs[1] - m_a[1] * m_outputs[1];
    m_inputs[1] = m_inputs[0];
    m_outputs[1] = m_lastValue;
    
    return m_lastValue;
}




//-----------------------------------------------------------------------------
// name: MoTwoPole()
// desc: ...
//-----------------------------------------------------------------------------
MoTwoPole :: MoTwoPole()
{
    SAMPLE B = 1.0;
    SAMPLE A[3] = { 1.0, 0.0, 0.0 };
    MoFilter::setCoefficients( 1, &B, 3, A );
}




//-----------------------------------------------------------------------------
// name: ~MoTwoPole()
// desc: ...
//-----------------------------------------------------------------------------
MoTwoPole :: ~MoTwoPole()
{ }




//-----------------------------------------------------------------------------
// name: setResonnance()
// desc: ...
//-----------------------------------------------------------------------------
void MoTwoPole :: setResonance( SAMPLE frequency, SAMPLE radius, bool normalize )
{
    m_a[2] = radius * radius;
    m_a[1] = (SAMPLE) -2.0 * radius * cos( TWO_PI * frequency / MoAudio::getSampleRate() );
    
    if( normalize ) 
    {
        // normalize the filter gain ... not terribly efficient.
        SAMPLE real = 1 - radius + (m_a[2] - radius) * cos( TWO_PI * 2 * frequency / MoAudio::getSampleRate());
        SAMPLE imag = (m_a[2] - radius) * sin( TWO_PI * 2 * frequency / MoAudio::getSampleRate());
        m_b[0] = sqrt( pow(real, 2) + pow(imag, 2) );
    }
}




//-----------------------------------------------------------------------------
// name: setCoefficients()
// desc: ...
//-----------------------------------------------------------------------------
void MoTwoPole :: setCoefficients( SAMPLE b0, SAMPLE a1, SAMPLE a2, bool clearState )
{
    m_b[0] = b0;
    m_a[1] = a1;
    m_a[2] = a2;
    
    if( clearState ) this->clear();
}




//-----------------------------------------------------------------------------
// name: tick()
// desc: ...
//-----------------------------------------------------------------------------
SAMPLE MoTwoPole :: tick( SAMPLE input )
{
    m_inputs[0] = m_gain * input;
    m_lastValue = m_b[0] * m_inputs[0] - m_a[1] * m_outputs[1] - m_a[2] * m_outputs[2];
    m_outputs[2] = m_outputs[1];
    m_outputs[1] = m_lastValue;
    
    return m_lastValue;
}




//-----------------------------------------------------------------------------
// name: MoTwoZero()
// desc: ...
//-----------------------------------------------------------------------------
MoTwoZero :: MoTwoZero()
{
    SAMPLE B[3] = { 1.0, 0.0, 0.0 };
    SAMPLE A = 1.0;
    MoFilter::setCoefficients( 3, B, 1, &A );
}




//-----------------------------------------------------------------------------
// name: ~MoTwoZero()
// desc: ...
//-----------------------------------------------------------------------------
MoTwoZero :: ~MoTwoZero()
{ }




//-----------------------------------------------------------------------------
// name: setCoefficients()
// desc: ...
//-----------------------------------------------------------------------------
void MoTwoZero :: setCoefficients( SAMPLE b0, SAMPLE b1, SAMPLE b2, bool clearState )
{
    m_b[0] = b0;
    m_b[1] = b1;
    m_b[2] = b2;

    if( clearState ) this->clear();
}




//-----------------------------------------------------------------------------
// name: setNotch()
// desc: ...
//-----------------------------------------------------------------------------
void MoTwoZero :: setNotch( SAMPLE frequency, SAMPLE radius )
{
    m_b[2] = radius * radius;
    m_b[1] = (SAMPLE) -2.0 * radius * cos( TWO_PI * (double) frequency / MoAudio::getSampleRate() );

    // normalize the filter gain.
    if( m_b[1] > 0.0 ) // maximum at z = 0.
        m_b[0] = 1.0 / (1.0+m_b[1]+m_b[2]);
    else            // maximum at z = -1.
        m_b[0] = 1.0 / (1.0-m_b[1]+m_b[2]);

    m_b[1] *= m_b[0];
    m_b[2] *= m_b[0];
}




//-----------------------------------------------------------------------------
// name: tick()
// desc: ...
//-----------------------------------------------------------------------------
SAMPLE MoTwoZero :: tick( SAMPLE sample )
{
    m_inputs[0] = m_gain * sample;
    m_lastValue = m_outputs[0] = m_b[2] * m_inputs[2] + m_b[1] * m_inputs[1] + m_b[0] * m_inputs[0];
    m_inputs[2] = m_inputs[1];
    m_inputs[1] = m_inputs[0];

    return m_outputs[0];
}




//-----------------------------------------------------------------------------
// name: class MoBiQuad()
// desc: ...
//-----------------------------------------------------------------------------
MoBiQuad :: MoBiQuad()
{
    SAMPLE B[3] = { 1.0, 0.0, 0.0 };
    SAMPLE A[3] = { 1.0, 0.0, 0.0 };
    MoFilter::setCoefficients( 3, B, 3, A );
}




//-----------------------------------------------------------------------------
// name: ~MoBiQuad()
// desc: ...
//-----------------------------------------------------------------------------
MoBiQuad :: ~MoBiQuad()
{ }




//-----------------------------------------------------------------------------
// name: setResonance()
// desc: ...
//-----------------------------------------------------------------------------
void MoBiQuad :: setResonance( SAMPLE frequency, SAMPLE radius, bool normalize )
{
    m_a[2] = radius * radius;
    m_a[1] = -2.0 * radius * cos( TWO_PI * frequency / MoAudio::getSampleRate() );
    
    if( normalize )
    {
        // use zeros at +- 1 and normalize the filter peak gain.
        m_b[0] = 0.5 - 0.5 * m_a[2];
        m_b[1] = 0.0;
        m_b[2] = -m_b[0];
    }
}




//-----------------------------------------------------------------------------
// name: setNotch()
// desc: ...
//-----------------------------------------------------------------------------
void MoBiQuad :: setNotch( SAMPLE frequency, SAMPLE radius )
{
    // this method does not attempt to normalize the filter gain.
    m_b[2] = radius * radius;
    m_b[1] = (SAMPLE) -2.0 * radius * cos( TWO_PI * (double)frequency / MoAudio::getSampleRate() );
}




//-----------------------------------------------------------------------------
// name: setEqualGainZeroes()
// desc: ...
//-----------------------------------------------------------------------------
void MoBiQuad :: setEqualGainZeroes()
{
    m_b[0] = 1.0;
    m_b[1] = 0.0;
    m_b[2] = -1.0;
}




//-----------------------------------------------------------------------------
// name: tick()
// desc: ...
//-----------------------------------------------------------------------------
SAMPLE MoBiQuad :: tick(SAMPLE sample)
{
    m_inputs[0] = m_gain * sample;
    m_outputs[0] = m_b[0] * m_inputs[0] + m_b[1] * m_inputs[1] + m_b[2] * m_inputs[2];
    m_outputs[0] -= m_a[2] * m_outputs[2] + m_a[1] * m_outputs[1];
    m_inputs[2] = m_inputs[1];
    m_inputs[1] = m_inputs[0];
    m_outputs[2] = m_outputs[1];
    m_outputs[1] = m_outputs[0];
    m_lastValue = m_outputs[0];
    
    return m_outputs[0];
}
