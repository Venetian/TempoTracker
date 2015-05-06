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
// name: mo_fun.mm
// desc: MoMu useful functions
//
// authors: Ge Wang (ge@ccrma.stanford.edu)
//    date: Winter 2010
//    version: 1.0.0
//
// Mobile Music research @ CCRMA, Stanford University:
//     http://momu.stanford.edu/
//-----------------------------------------------------------------------------
#include "mo_fun.h"


//-----------------------------------------------------------------------------
// name: rand2i()
// desc: generates random int in [low, high]
//-----------------------------------------------------------------------------
long MoFun::rand2i( long low, long high )
{
    // swap
    if( low > high ) low ^= high ^= low ^= high;
    // diff
    long diff = high - low;
    // go
    return low + random() % diff;
}


//-----------------------------------------------------------------------------
// name: rand2f()
// desc: generates random double in [low, high]
//-----------------------------------------------------------------------------
double MoFun::rand2f( double low, double high )
{
    // swap
    if( low > high ) {
        double temp = low; low = high; high = temp;
    }
    
    // diff
    double diff = high - low;
    // go
    return low + diff * random() / (double)0x8fffffff;
}
