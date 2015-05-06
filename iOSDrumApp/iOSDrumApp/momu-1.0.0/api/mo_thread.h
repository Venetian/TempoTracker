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
// name: mo_thread.h
// desc: defines for threads
//
// authors: Ge Wang (ge@ccrma.stanford.edu)
//          adapted from ChucK adapted from STK
//    date: Fall 2009
//    version: 1.0.0
//
// Mobile Music research @ CCRMA, Stanford University:
//     http://momu.stanford.edu/
//-----------------------------------------------------------------------------
#ifndef __MO_THREAD_H__
#define __MO_THREAD_H__

#include "mo_def.h"
#include <pthread.h>

#define THREAD_TYPE
typedef pthread_t THREAD_HANDLE;
typedef void * THREAD_RETURN;
typedef void * (*THREAD_FUNCTION)(void *);
typedef pthread_mutex_t MUTEX;


//-----------------------------------------------------------------------------
// name: struct MoThread
// desc: ...
//-----------------------------------------------------------------------------
struct MoThread
{
public:
    MoThread();
    ~MoThread();

public:
    // begin execution of the thread routine
    // the thread routine can be passed an argument via ptr
    bool start( THREAD_FUNCTION routine, void * ptr = NULL );

    // wait the specified number of milliseconds for the thread to terminate
    bool wait( long milliseconds = -1 );
    
    // set priority
    bool setPriority( long priority );
    
public:
    // set current thread priority
    static bool setSelfPriority( long priority );

public:
    // test for a thread cancellation request.
    static void test( );
    
    // clear
    void clear() { thread = 0; }

protected:
    THREAD_HANDLE thread;
};




//-----------------------------------------------------------------------------
// name: struct MoMutex
// desc: ...
//-----------------------------------------------------------------------------
struct MoMutex
{
public:
    MoMutex();
    ~MoMutex();

public:
    void acquire( );
    void release(void);

protected:
    MUTEX mutex;
};




#endif
