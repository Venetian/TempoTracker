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
// name: mo_net.h
// desc: MoPhO API for networking
//
// note: ( mo_net is pronounced "Monet" )
//       - you need to add MoMu version of OSCpack to the project
//
// authors: Jorge Herrera 
//          Jieun Oh
//          Nick Bryan
//          Ge Wang
//
//    date: Fall 2009
//    version: 1.0.0
//
// Mobile Music research @ CCRMA, Stanford University:
//     http://momu.stanford.edu/
//-----------------------------------------------------------------------------
#ifndef __MO_NET_H__
#define __MO_NET_H__

#include "mo_def.h"
#include "mo_thread.h"

#include "UdpSocket.h"
#include "OscReceivedElements.h"
#include "OscPacketListener.h"
#include "OscOutboundPacketStream.h"

#include <iostream>
#include <map>


//-----------------------------------------------------------------------------
// name: class MoNetOSCPacketListener
// desc: listen to incoming OSC messages
//-----------------------------------------------------------------------------
class MoNetOSCPacketListener : public osc::OscPacketListener
{   
protected:
    // Process the recieved messages
    virtual void ProcessMessage( const osc::ReceivedMessage & m, 
                                 const IpEndpointName & remoteEndpoint );
};

class MoNetSender 
{
    // TODO: implement me
};

// Type of callback to handle received OSC messages.
typedef void ( * MoNetReceiveCallback )( osc::ReceivedMessageArgumentStream 
                                         & argument_stream, 
                                         void * data );


//-----------------------------------------------------------------------------
// name: struct MoNet
// desc: hold a OSC Receive Callback and its associated data
//-----------------------------------------------------------------------------
struct MoNetCallback
{
    MoNetReceiveCallback callback;
    void * data;
};


//-----------------------------------------------------------------------------
// name: class MoNet
// desc: network stuff  ( singleton )
//-----------------------------------------------------------------------------
class MoNet
{
public:   
    
    // Register and Unregister callbacks to handle specific pattern address 
    // (messages)
    static void addAddressCallback(
        const std::string pattern, 
        const MoNetReceiveCallback & callback, 
        void * data = NULL );
    static void removeAddressCallback( const std::string pattern );
    
    // Setter & getter for the listening port
    static void setListeningPort( long port );
    static long getListeningPort();
    
    // Start & stop the thread that listen to incoming OSC messages
    static void startListening();
    static void stopListening();
    
    // List of pattern addresses ( key ) and respective callbacks ( value )
    // FIXME: this should be private ( and static ), but then it was harder 
    // to get acces to it from MoNetOSCPacketListener
    static std::map<std::string, MoNetCallback> m_pattern_callbacks;
    
    // Sends an OSC message with variable number and type of arguments
    // 
    // 'ip' is a string with the destination ip ( e.g, "127.0.0.1" )
    // 'port' is the destination port ( e.g. 8888 )
    // 'pattern_address' is the pattern of the message ( e.g. /momu/test  )
    // 'types' is and array of chars cointaining the types of the different OSC 
    // variables to be send. It can be defined as: 
    //              char types[num_vars] = {'i', 'f', 's'};
    // 'size' is the number of variables to be send ( must be the same length
    // as the types array.
    // After the 'size' argument, a comma separated list of varibles to be sent,
    // must be provided. The order must be the same as the order specified in 
    // the types array
    static void sendMessage(
        const std::string &ip, 
        uint port, 
        const std::string &pattern_address, 
        char types[], 
        uint size, 
        ... );

public:
    static std::string getMyIPaddress();

public:
    // hash-map to cache sockest associated to remote machines
    static std::map<std::string, UdpTransmitSocket *> m_cache;
    static void clearCache();

private:
    // OSC listening thread
    static MoThread m_thread;
    static bool m_thread_started;
    // listening port
    static long m_listening_port;
    // Output buffer size
    static unsigned int m_output_buffer_size;

    // converter
    static unsigned int stringIPtoHEX( const std::string & ip );
    
private:
    // Launches the listening thread
    static void * cb_osc_listener( void * );    
};


#endif
