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
// name: mo_thread.cpp
// desc: wrapper threads
//
// authors: Ge Wang (ge@ccrma.stanford.edu)
//          adapted from ChucK adapted from STK
//    date: October 2009
//    version: 1.0.0
//
// Mobile Music research @ CCRMA, Stanford University:
//     http://momu.stanford.edu/
//-----------------------------------------------------------------------------
#include "mo_thread.h"
#include <iostream>




//-----------------------------------------------------------------------------
// name: MoThread()
// desc: ...
//-----------------------------------------------------------------------------
MoThread::MoThread()
{
    thread = 0;
}




//-----------------------------------------------------------------------------
// name: ~MoThread()
// desc: ...
//-----------------------------------------------------------------------------
MoThread::~MoThread()
{
    if( thread != 0 )
    {
        pthread_cancel( thread );
        pthread_join( thread, NULL );
    }
}




//-----------------------------------------------------------------------------
// name: start()
// desc: ...
//-----------------------------------------------------------------------------
bool MoThread::start( THREAD_FUNCTION routine, void * ptr )
{
    bool result = false;
    
    if( pthread_create( &thread, NULL, *routine, ptr ) == 0 )
        result = true;

    return result;
}




//-----------------------------------------------------------------------------
// name: wait()
// desc: ...
//-----------------------------------------------------------------------------
bool MoThread::wait( long milliseconds )
{
    bool result = false;
    
    pthread_cancel( thread );
    pthread_join( thread, NULL );

    return result;
}




//-----------------------------------------------------------------------------
// name: test()
// desc: ...
//-----------------------------------------------------------------------------
void MoThread::test()
{
    pthread_testcancel();
}




//-----------------------------------------------------------------------------
// name: MoMutex()
// desc: ...
//-----------------------------------------------------------------------------
MoMutex::MoMutex()
{
    pthread_mutex_init(&mutex, NULL);
}




//-----------------------------------------------------------------------------
// name: MoMutex()
// desc: ...
//-----------------------------------------------------------------------------
MoMutex::~MoMutex()
{
    pthread_mutex_destroy( &mutex );
}




//-----------------------------------------------------------------------------
// name: acquire()
// desc: ...
//-----------------------------------------------------------------------------
void MoMutex::acquire()
{
    pthread_mutex_lock( &mutex );
}




//-----------------------------------------------------------------------------
// name: unlock()
// desc: ...
//-----------------------------------------------------------------------------
void MoMutex::release()
{
    pthread_mutex_unlock( &mutex );
}




//-----------------------------------------------------------------------------
// name: setPriority()
// desc: ...
//-----------------------------------------------------------------------------
bool setPriority( pthread_t thread, long priority )
{
    struct sched_param param;
    int policy;
    
    // log
    std::cerr << "[mopho]: setting thread priority to: " << priority << "..." << std::endl;
    
    // get for thread
    if( pthread_getschedparam( thread, &policy, &param) ) 
        goto doh;
    
    // priority
    param.sched_priority = priority;
    // policy
    policy = SCHED_RR;
    // set for thread
    if( pthread_setschedparam( thread, policy, &param ) )
        goto doh;
    
    return true;
    
doh:
    // log
    std::cerr << "[mopho]: failed to set thread priority!" << std::endl;
    
    return false;
}




//-----------------------------------------------------------------------------
// name: setPriority()
// desc: ...
//-----------------------------------------------------------------------------
bool MoThread::setPriority( long priority )
{
    return ::setPriority( thread, priority );
}




//-----------------------------------------------------------------------------
// name: setSelfPriority()
// desc: ...
//-----------------------------------------------------------------------------
bool MoThread::setSelfPriority( long priority )
{
    return ::setPriority( pthread_self(), priority );
}
