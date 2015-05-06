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
// name: mo_net.mm
// desc: MoPhO API for networking
//
// authors: Jorge Herrera
//          Nick Bryan
//          Jieun Oh
//          Ge Wang
//
//    date: Fall 2009
//    version: 1.0.0
//
// Mobile Music research @ CCRMA, Stanford University:
//     http://momu.stanford.edu/
//-----------------------------------------------------------------------------
#include "mo_net.h"
#include <stdarg.h>
#include <ifaddrs.h> 
#include <arpa/inet.h>


//-----------------------------------------------------------------------------
// name: instance()
// desc: get instance of MoNet
//-----------------------------------------------------------------------------
MoThread MoNet::m_thread;
bool MoNet::m_thread_started = false;
long MoNet::m_listening_port = 6449;
unsigned int MoNet::m_output_buffer_size = 1024;
std::map<std::string, MoNetCallback> MoNet::m_pattern_callbacks;
std::map<std::string, UdpTransmitSocket *> MoNet::m_cache;


//-----------------------------------------------------------------------------
// name: startListening()
// desc: Start a new thread that will listen to incomming OSC messages
//-----------------------------------------------------------------------------
void MoNet::startListening()
{
    if( !m_thread_started ) {
        m_thread_started = true;
        m_thread.start( MoNet::cb_osc_listener );
    } else {
        std::cout << "Thread has already been started\n";
    }
}


//-----------------------------------------------------------------------------
// name: stopListening()
// desc: Will kill the listening thread
//-----------------------------------------------------------------------------
void MoNet::stopListening()
{
    // TODO: figure out how to stop it
}


//-----------------------------------------------------------------------------
// name: addAddressCallback()
// desc: Register a callback to get called with a particular OSC message address
//-----------------------------------------------------------------------------
void MoNet::addAddressCallback( const std::string pattern, 
                                const MoNetReceiveCallback & callback, 
                                void * data  )
{
    // m_pattern_callbacks[pattern] = callback;
    MoNetCallback cbk;
    cbk.callback = callback;
    cbk.data = data;
    MoNet::m_pattern_callbacks[pattern] = cbk;
}


//-----------------------------------------------------------------------------
// name: removeAddressCallback()
// desc: Will unregister a specific callback
//-----------------------------------------------------------------------------
void MoNet::removeAddressCallback( const std::string pattern )
{
    std::map<std::string, MoNetCallback>::iterator it = 
                                   MoNet::m_pattern_callbacks.find( pattern );
    if( it != MoNet::m_pattern_callbacks.end() ) 
        MoNet::m_pattern_callbacks.erase( it );
}


//-----------------------------------------------------------------------------
// name: setListeningPort()
// desc: Defines the port that listens to incomming OSC messages
//-----------------------------------------------------------------------------
void MoNet::setListeningPort( long port )
{
    m_listening_port = port;
}


//-----------------------------------------------------------------------------
// name: getListeningPort()
// desc: Get the currently registered listening port
//-----------------------------------------------------------------------------
long MoNet::getListeningPort() 
{
    return m_listening_port;
}


//-----------------------------------------------------------------------------
// name: ProcessMessage()
// desc: Private function that process an incomming message and calls the 
//       corresponding callback
//-----------------------------------------------------------------------------
void MoNetOSCPacketListener::ProcessMessage( const osc::ReceivedMessage & m, 
                                             const IpEndpointName & remoteEndpoint )
{
    try
    {
        std::string pattern = m.AddressPattern();
        std::map<std::string, MoNetCallback>::iterator it = 
            MoNet::m_pattern_callbacks.find( pattern );
        
        if( it != MoNet::m_pattern_callbacks.end() ) {
            osc::ReceivedMessageArgumentStream args = m.ArgumentStream();
            MoNet::m_pattern_callbacks[pattern].callback( args, MoNet::m_pattern_callbacks[pattern].data );
        } else {
            std::cerr << "[mopho]: no callback has been registerd for: '"
                      << pattern  << "' pattern address\n";
        }
    }
    catch( osc::Exception & e )
    {
        std::cerr << "[mopho]: error while parsing message: "
                  << m.AddressPattern() << ": " << e.what() << "\n";
    }
}


//-----------------------------------------------------------------------------
// name: cb_osc_listener()
// desc: Private method to starts the new thread that listens to OSC messages
//-----------------------------------------------------------------------------
void * MoNet::cb_osc_listener( void * )
{
    // instantiate listener
    MoNetOSCPacketListener listener;
    long port = MoNet::getListeningPort();
    
    UdpListeningReceiveSocket s( IpEndpointName( IpEndpointName::ANY_ADDRESS, 
                                                 port), &listener );
    
    // print
    std::cerr << "[mopho]: OSC listener started on port: ";
    std::cerr << port << "..." << std::endl;
    
    // set priority
    MoThread::setSelfPriority( 95 );
    
    // go!
    s.RunUntilSigInt();
    
    return NULL;
}


//-----------------------------------------------------------------------------
// name: clearCache()
// desc: clears cache
//-----------------------------------------------------------------------------
void MoNet::clearCache()
{
    // iterate through cache
    std::map<std::string, UdpTransmitSocket *>::iterator iter;
    for( iter = m_cache.begin(); iter != m_cache.end(); iter++ )
    {
        // delete
        delete iter->second;
    }
    // clear the cache
    m_cache.clear();
}


//-----------------------------------------------------------------------------
// name: sendMessage()
// desc: Sends an OSC message
//-----------------------------------------------------------------------------
void MoNet::sendMessage( const std::string &ip, 
                         uint port, 
                         const std::string &pattern_address, 
                         char types[], 
                         uint size, 
                         ... )
{
    // unsigned int ipHex = stringIPtoHEX( ip );
    std::string ipHex = ip;
    // out
    UdpTransmitSocket * x = NULL;
    
    // check to see if in cache
    if( m_cache.find( ip ) == m_cache.end() )
    {
        // DONE? this could be opened only once somewhere else to improve performance.
        x = new UdpTransmitSocket( IpEndpointName( ip.c_str(), port ) );
        // insert
        m_cache[ip] = x;
    }
    else
    {
        // get it
        x = m_cache[ip];
    }
    
    char buffer[MoNet::m_output_buffer_size];
    osc::OutboundPacketStream p( buffer, MoNet::m_output_buffer_size );
    
    // Macros to read the variable arguments
    va_list args;
    va_start( args, size ); 
    // TODO: do we want to send bundles or just messages?
    p << osc::BeginBundleImmediate << osc::BeginMessage( pattern_address.c_str() );
    for( int i = 0; i < size; i++ )
    {
        if( types[i] == 'i' ) { // OSC-int32 
            p << va_arg( args, int );
        }
        else if( types[i] == 'f' ) { // OSC-float32
            // va_args requires double instead float values
            p << ( float )va_arg( args, double ); 
        }
        else if( types[i] == 's' ) { // OSC-string
            p << va_arg( args, char* );
        }
        // TODO: handle OSC-blob type, defined in the OSC specs
    }
    va_end( args );
    
    p << osc::EndMessage << osc::EndBundle;
    x->Send( p.Data(), p.Size() );
}


//-----------------------------------------------------------------------------
// name: stringIPtoHEX
// desc: Private utilitary method that given an IP string, returns the 
//       corresponding Hexadecimal number
//-----------------------------------------------------------------------------
unsigned int MoNet::stringIPtoHEX( const std::string & ip )
{
    std::string delimiters = ".";
    unsigned int ipHex = 0;
    unsigned int i = 0;
    
    std::string::size_type last = ip.find_first_not_of( delimiters, 0 );
    std::string::size_type pos  = ip.find_first_of( delimiters, last );
    
    while( std::string::npos != pos || std::string::npos != last )
    {
        ipHex += ( atoi( ip.substr( last, pos - last ).c_str() ) << ( 3-i++ ) * 8 );
        last = ip.find_first_not_of( delimiters, pos );
        pos = ip.find_first_of( delimiters, last );
    }

    return ipHex;
}


//-----------------------------------------------------------------------------
// name: getMyIPaddress()
// desc: static method to retrieve the wifi IP address of the iPhone (based on 
// http://zachwaugh.com/2009/03/programmatically-retrieving-ip-address-of-iphone/ )
//-----------------------------------------------------------------------------
std::string MoNet::getMyIPaddress()
{
    std::string address = "error"; 
    struct ifaddrs *interfaces = NULL; 
    struct ifaddrs *temp_addr = NULL; 
    int success = 0;
    
    // retrieve the current interfaces - returns 0 on success  
    success = getifaddrs(&interfaces); 
    if( success == 0 )
    { 
        // loop through linked list of interfaces  
        temp_addr = interfaces; 
        while( temp_addr != NULL )
        { 
            if(temp_addr->ifa_addr->sa_family == AF_INET)
            { 
                // check if interface is en0 which is the wifi connection on the iPhone  
                if([[NSString stringWithUTF8String:temp_addr->ifa_name] isEqualToString:@"en0"])
                { 
                    // get NSString from C String  
                    address = inet_ntoa(((struct sockaddr_in *)temp_addr->ifa_addr)->sin_addr);
                } 
            } 
            temp_addr = temp_addr->ifa_next; 
        } 
    }
    
    // free memory  
    freeifaddrs(interfaces); 
    
    return address;
}
