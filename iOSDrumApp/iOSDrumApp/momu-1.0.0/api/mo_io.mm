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
// name: mo_io.cpp
// desc: MoPhO API for common input/output operations
//
// authors: Ge Wang( ge@ccrma.stanford.edu )
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
#include "mo_io.h"
#include <sys/stat.h>
#include <sys/types.h>
#include <math.h>
#include <string.h>
#include <iostream>
#include "mo_audio.h"
// #include "util_raw.h"


#define CHUNK_THRESHOLD 5000000  // 5 Mb
#define CHUNK_SIZE 1024          // sample frames
union what { long x; char y[sizeof(long)]; };
long little_endian = TRUE;

const MoAudioFileIn::STK_FORMAT MoAudioFileIn::STK_SINT8 = 1;
const MoAudioFileIn::STK_FORMAT MoAudioFileIn::STK_SINT16 = 2;
const MoAudioFileIn::STK_FORMAT MoAudioFileIn::STK_SINT32 = 8;
const MoAudioFileIn::STK_FORMAT MoAudioFileIn::MY_FLOAT32 = 16;
const MoAudioFileIn::STK_FORMAT MoAudioFileIn::MY_FLOAT64 = 32;

static void swap32( unsigned char * ptr )
{
    register unsigned char val;
    
    // swap 1st and 4th bytes
    val = *(ptr);
    *(ptr) = *(ptr+3);
    *(ptr+3) = val;
    
    // swap 2nd and 3rd bytes
    ptr += 1;
    val = *(ptr);
    *(ptr) = *(ptr+1);
    *(ptr+1) = val;
}

static void swap16( unsigned char * ptr )
{
    register unsigned char val;
    
    // swap 1st and 2nd bytes
    val = *(ptr);
    *(ptr) = *(ptr+1);
    *(ptr+1) = val;
}

static void swap64( unsigned char * ptr )
{
    register unsigned char val;
    
    // swap 1st and 8th bytes
    val = *(ptr);
    *(ptr) = *(ptr+7);
    *(ptr+7) = val;
    
    // swap 2nd and 7th bytes
    ptr += 1;
    val = *(ptr);
    *(ptr) = *(ptr+5);
    *(ptr+5) = val;
    
    // swap 3rd and 6th bytes
    ptr += 1;
    val = *(ptr);
    *(ptr) = *(ptr+3);
    *(ptr+3) = val;
    
    // swap 4th and 5th bytes
    ptr += 1;
    val = *(ptr);
    *(ptr) = *(ptr+1);
    *(ptr+1) = val;
}

MoAudioFileIn::MoAudioFileIn()
{
    init();
}

MoAudioFileIn::~MoAudioFileIn()
{
    if( fd )
        fclose( fd );
    
    if( data )
        delete [] data;
    
    if( lastOutput )
        delete [] lastOutput;
    
    m_loaded = false;
}

void MoAudioFileIn::init()
{
    fd = 0;
    m_loaded = false;
    m_filename ="";
    m_gain = 1.0f;
    data = 0;
    lastOutput = 0;
    chunking = false;
    finished = true;
    interpolate = false;
    bufferSize = 0;
    channels = 0;
    time = 0.0;
}

void MoAudioFileIn::closeFile()
{
    if( fd ) fclose( fd );
    fd = 0;
    m_loaded = false;
    finished = true;
}


bool MoAudioFileIn::openFile( const char * fileName, const char * extension, bool raw, bool doNormalize, bool generate )
{   
    unsigned long lastChannels = channels;
    unsigned long samples, lastSamples =( bufferSize+1 )*channels;
    
    NSString * tempStr = [NSString stringWithUTF8String:fileName];
    NSString * tempExt = [NSString stringWithUTF8String:extension];
    m_filename = [[[NSBundle mainBundle] pathForResource: tempStr ofType:tempExt] UTF8String];      
        
    if( !generate || !strstr( m_filename, "special:" ) )
    {
        closeFile();
        
        // try to open the file
        fd = fopen( m_filename, "rb" );
        if( !fd ) {
            fprintf( stderr, "[mopho](via MoAudioFileIn): could not open or find file( %s ).", m_filename );
            // handleError( msg, StkError::FILE_NOT_FOUND );
            return false;
        }
        
        bool result = false;
        if( raw )
            result = getRawInfo( m_filename );
        else
        {
            char header[12];
            if( fread( &header, 4, 3, fd ) != 3 ) goto error;
            if( !strncmp( header, "RIFF", 4 ) &&
               !strncmp( &header[8], "WAVE", 4 ) )
                result = getWavInfo( m_filename );
            else if( !strncmp( header, ".snd", 4 ) )
                result = getSndInfo( m_filename );
            else if( !strncmp( header, "FORM", 4 ) &&
                    ( !strncmp( &header[8], "AIFF", 4 ) || !strncmp( &header[8], "AIFC", 4 ) ) )
                result = getAifInfo( m_filename );
            else {
                if( fseek( fd, 126, SEEK_SET ) == -1 ) goto error;
                if( fread( &header, 2, 1, fd ) != 1 ) goto error;
                if( !strncmp( header, "MI", 2 ) ||
                   !strncmp( header, "IM", 2 ) )
                    result = getMatInfo( m_filename );
                else {
                    raw = TRUE;
                    result = getRawInfo( m_filename );
                    // sprintf( msg, "WvIn: File( %s ) format unknown.", fileName );
                    // handleError( msg, StkError::FILE_UNKNOWN_FORMAT );
                }
            }
        }
        
        if( result == false )
        {
            // handleError( msg, StkError::FILE_ERROR );
            return false;
        }
        
        if( fileSize == 0 ) {
            fprintf( stderr, "[mopho](via MoAudioFileIn): file( %s ) data size is zero!", m_filename );
            // handleError( msg, StkError::FILE_ERROR );
            return false;
        }
    }
    else
    {
        bufferSize = 1024;
        channels = 1;
    }
    
    // allocate new memory if necessary.
    samples = ( bufferSize+1 )*channels;
    if( lastSamples < samples ) {
        if( data ) delete [] data;
        data = (SAMPLE *) new SAMPLE[samples];
    }
    if( lastChannels < channels ) {
        if( lastOutput ) delete [] lastOutput;
        lastOutput = (SAMPLE *) new SAMPLE[channels];
    }
    
    if( fmod( rate, 1.0 ) != 0.0 ) interpolate = true;
    chunkPointer = 0;
    
    reset();
    if( !readData( 0 ) )  // load file data
    {
        goto error;
    }
    
    if( doNormalize ) normalize();
    m_loaded = true;
    finished = false;
    interpolate = ( fmod( rate, 1.0 ) != 0.0 );
    return true;
    
error:
    fprintf( stderr, "[mopho](via MoAudioFileIn): error reading file( %s ).", fileName );
    // handleError( msg, StkError::FILE_ERROR );
    return false;
}

bool MoAudioFileIn::getRawInfo( const char *fileName )
{
    // use the system call "stat" to determine the file length
    struct stat filestat;
    if( stat( fileName, &filestat ) == -1 ) {
        fprintf( stderr, "[mopho](via MoAudilFileIn): could not stat RAW file( %s ).", fileName );
        return false;
    }
    
    fileSize =( long ) filestat.st_size / 2;  // length in 2-byte samples
    bufferSize = fileSize;
    if( fileSize > CHUNK_THRESHOLD ) {
        chunking = true;
        bufferSize = CHUNK_SIZE;
        gain = 1.0 / 32768.0;
    }
    
    // STK rawwave files have no header and are assumed to contain a
    // monophonic stream of 16-bit signed integers in big-endian byte
    // order with a sample rate of 22050 Hz.
    channels = 1;
    dataOffset = 0;
    rate = (SAMPLE) 22050.0 / MoAudio::getSampleRate();
    fileRate = 22050.0;
    interpolate = false;
    dataType = STK_SINT16;
    byteswap = false;
    if( little_endian )
        byteswap = true;
    
    return true;
}

bool MoAudioFileIn::getWavInfo( const char *fileName )
{
    // find "format" chunk ... it must come before the "data" chunk
    char id[4];
    long chunkSize;
    if( fread( &id, 4, 1, fd ) != 1 ) goto error;
    while( strncmp( id, "fmt ", 4 ) ) {
        if( fread( &chunkSize, 4, 1, fd ) != 1 ) goto error;
        if( !little_endian )
            swap32( (unsigned char *)&chunkSize );
        
        if( fseek( fd, chunkSize, SEEK_CUR ) == -1 ) goto error;
        if( fread( &id, 4, 1, fd ) != 1 ) goto error;
    }
    
    // check that the data is not compressed
    short format_tag;
    if( fread( &chunkSize, 4, 1, fd ) != 1 ) goto error; // read fmt chunk size
    if( fread( &format_tag, 2, 1, fd ) != 1 ) goto error;
    if( !little_endian )
    {
        swap16( (unsigned char *)&format_tag );
        swap32( (unsigned char *)&chunkSize );
    }
    if( format_tag != 1 && format_tag != 3 ) { // PCM = 1, FLOAT = 3
        fprintf( stderr, "[mopho](via MoAudilFileIn): %s contains unsupported format type( %d ).", fileName, format_tag );
        return false;
    }
    
    // Get number of channels from the header.
    // SINT16 temp;
    short temp;
    
    if( fread( &temp, 2, 1, fd ) != 1 ) goto error;
    if( !little_endian )
        swap16( (unsigned char *)&temp );
    
    channels = (unsigned int)temp;
    
    // get file sample rate from the header
    // SINT32 srate;
    long srate;
    
    if( fread( &srate, 4, 1, fd ) != 1 ) goto error;
    if( !little_endian )
        swap32( (unsigned char *)&srate );
    
    fileRate = (SAMPLE) srate;
    
    // set default rate based on file sampling rate
    rate = (SAMPLE)( srate / MoAudio::getSampleRate() );
    
    // determine the data type
    dataType = 0;
    if( fseek( fd, 6, SEEK_CUR ) == -1 ) goto error; // locate bits_per_sample info
    if( fread( &temp, 2, 1, fd ) != 1 ) goto error;
    if( !little_endian )
        swap16( (unsigned char *)&temp );
    
    if( format_tag == 1 ) {
        if( temp == 8 )
            dataType = STK_SINT8;
        else if( temp == 16 )
            dataType = STK_SINT16;
        else if( temp == 32 )
            dataType = STK_SINT32;
    }
    else if( format_tag == 3 ) {
        if( temp == 32 )
            dataType = MY_FLOAT32;
        else if( temp == 64 )
            dataType = MY_FLOAT64;
    }
    if( dataType == 0 ) {
        fprintf( stderr, "[mopho](via MoAudilFileIn): %d bits/sample with format %d not supported( %s ).", 
                temp, format_tag, fileName );
        return false;
    }
    
    // jump over any remaining part of the "fmt" chunk
    if( fseek( fd, chunkSize-16, SEEK_CUR ) == -1 ) goto error;
    
    // find "data" chunk ... it must come after the "fmt" chunk
    if( fread( &id, 4, 1, fd ) != 1 ) goto error;
    
    while( strncmp( id, "data", 4 ) ) {
        if( fread( &chunkSize, 4, 1, fd ) != 1 ) goto error;
        if( !little_endian )
            swap32( (unsigned char *)&chunkSize );
        
        if( fseek( fd, chunkSize, SEEK_CUR ) == -1 ) goto error;
        if( fread( &id, 4, 1, fd ) != 1 ) goto error;
    }
    
    // Get length of data from the header.
    // SINT32 bytes;
    long bytes;
    
    if( fread( &bytes, 4, 1, fd ) != 1 ) goto error;
    if( !little_endian )
        swap32( (unsigned char *)&bytes );
    
    fileSize = 8 * bytes / temp / channels;  // sample frames
    bufferSize = fileSize;
    if( fileSize > CHUNK_THRESHOLD ) {
        chunking = true;
        bufferSize = CHUNK_SIZE;
    }
    
    dataOffset = ftell( fd );
    byteswap = false;
    if( !little_endian )
        byteswap = true;
    
    return true;
    
error:
    fprintf( stderr, "[mopho](via MoAudilFileIn): error reading WAV file( %s ).", fileName );
    return false;
}

bool MoAudioFileIn::getSndInfo( const char *fileName )
{
    // determine the data type
    // SINT32 format;
    long format;
    
    if( fseek( fd, 12, SEEK_SET ) == -1 ) goto error; // locate format
    if( fread( &format, 4, 1, fd ) != 1 ) goto error;
    if( little_endian )
        swap32( (unsigned char *)&format );
    
    if( format == 2 ) dataType = STK_SINT8;
    else if( format == 3 ) dataType = STK_SINT16;
    else if( format == 5 ) dataType = STK_SINT32;
    else if( format == 6 ) dataType = MY_FLOAT32;
    else if( format == 7 ) dataType = MY_FLOAT64;
    else {
        fprintf( stderr, "[mopho](via MoAudilFileIn): format in file %s not supported.", fileName );
        return false;
    }
    
    // Get file sample rate from the header.
    // SINT32 srate;
    long srate;
    
    if( fread( &srate, 4, 1, fd ) != 1 ) goto error;
    if( little_endian )
        swap32( (unsigned char *)&srate );
    
    fileRate = (SAMPLE) srate;
    
    // Set default rate based on file sampling rate.
    rate = (SAMPLE)( srate / MoAudio::getSampleRate() );
    
    // Get number of channels from the header.
    // SINT32 chans;
    long chans;
    
    if( fread( &chans, 4, 1, fd ) != 1 ) goto error;
    if( little_endian )
        swap32( (unsigned char *)&chans );
    
    channels = chans;
    
    if( fseek( fd, 4, SEEK_SET ) == -1 ) goto error;
    if( fread( &dataOffset, 4, 1, fd ) != 1 ) goto error;
    if( little_endian )
        swap32( (unsigned char *)&dataOffset );
    
    // get length of data from the header
    if( fread( &fileSize, 4, 1, fd ) != 1 ) goto error;
    if( little_endian )
        swap32( (unsigned char *)&fileSize );
    
    fileSize /= 2 * channels;  // Convert to sample frames.
    bufferSize = fileSize;
    if( fileSize > CHUNK_THRESHOLD ) {
        chunking = true;
        bufferSize = CHUNK_SIZE;
    }
    
    byteswap = false;
    if( little_endian )
        byteswap = true;
    
    return true;
    
error:
    fprintf( stderr, "[mopho](via MoAudilFileIn): error reading SND file( %s ).", fileName );
    return false;
}

bool MoAudioFileIn::getAifInfo( const char *fileName )
{
    bool aifc = false;
    char id[4];
    
    // determine whether this is AIFF or AIFC
    if( fseek( fd, 8, SEEK_SET ) == -1 ) goto error;
    if( fread( &id, 4, 1, fd ) != 1 ) goto error;
    if( !strncmp( id, "AIFC", 4 ) ) aifc = true;
    
    // find "common" chunk
    // SINT32 chunkSize;
    long chunkSize;
    
    if( fread( &id, 4, 1, fd ) != 1 ) goto error;
    while( strncmp( id, "COMM", 4 ) ) {
        if( fread( &chunkSize, 4, 1, fd ) != 1 ) goto error;
        if( little_endian )
            swap32( (unsigned char *)&chunkSize );
        
        if( fseek( fd, chunkSize, SEEK_CUR ) == -1 ) goto error;
        if( fread( &id, 4, 1, fd ) != 1 ) goto error;
    }
    
    // get number of channels from the header
    // SINT16 temp;
    short temp;
    
    if( fseek( fd, 4, SEEK_CUR ) == -1 ) goto error; // jump over chunk size
    if( fread( &temp, 2, 1, fd ) != 1 ) goto error;
    if( little_endian )
        swap16( (unsigned char *)&temp );
    
    channels = temp;
    
    // get length of data from the header
    // SINT32 frames;
    long frames;
    
    if( fread( &frames, 4, 1, fd ) != 1 ) goto error;
    if( little_endian )
        swap32( (unsigned char *)&frames );
    
    fileSize = frames; // sample frames
    bufferSize = fileSize;
    if( fileSize > CHUNK_THRESHOLD ) {
        chunking = true;
        bufferSize = CHUNK_SIZE;
    }
    
    // read the number of bits per sample
    if( fread( &temp, 2, 1, fd ) != 1 ) goto error;
    if( little_endian )
        swap16( (unsigned char *)&temp );
    
    // get file sample rate from the header.  For AIFF files, this value
    // is stored in a 10-byte, IEEE Standard 754 floating point number,
    // so we need to convert it first
    unsigned char srate[10];
    unsigned char exp;
    unsigned long mantissa;
    unsigned long last;
    if( fread( &srate, 10, 1, fd ) != 1 ) goto error;
    mantissa = (unsigned long)*(unsigned long *)( srate+2 );
    if( little_endian )
        swap32( (unsigned char *)&mantissa );
    
    exp = 30 - * (srate+1);
    last = 0;
    while( exp-- ) {
        last = mantissa;
        mantissa >>= 1;
    }
    if( last & 0x00000001 ) mantissa++;
    fileRate = (SAMPLE) mantissa;
    
    // set default rate based on file sampling rate.
    rate = (SAMPLE)( fileRate / MoAudio::getSampleRate() );
    
    // determine the data format
    dataType = 0;
    if( aifc == false ) {
        if( temp == 8 ) dataType = STK_SINT8;
        else if( temp == 16 ) dataType = STK_SINT16;
        else if( temp == 32 ) dataType = STK_SINT32;
    }
    else {
        if( fread( &id, 4, 1, fd ) != 1 ) goto error;
        if( ( !strncmp( id, "fl32", 4 ) || !strncmp( id, "FL32", 4 ) ) && temp == 32 ) dataType = MY_FLOAT32;
        else if( ( !strncmp( id, "fl64", 4 ) || !strncmp( id, "FL64", 4 ) ) && temp == 64 ) dataType = MY_FLOAT64;
    }
    if( dataType == 0 ) {
        fprintf( stderr, "[mopho](via MoAudilFileIn): %d bits/sample in file %s not supported.", 
                temp, fileName );
        return false;
    }
    
    // start at top to find data( SSND ) chunk ... chunk order is undefined
    if( fseek( fd, 12, SEEK_SET ) == -1 ) goto error;
    
    // find data( SSND ) chunk
    if( fread( &id, 4, 1, fd ) != 1 ) goto error;
    while( strncmp( id, "SSND", 4 ) ) {
        if( fread( &chunkSize, 4, 1, fd ) != 1 ) goto error;
        if( little_endian )
            swap32( (unsigned char *)&chunkSize );
        
        if( fseek( fd, chunkSize, SEEK_CUR ) == -1 ) goto error;
        if( fread( &id, 4, 1, fd ) != 1 ) goto error;
    }
    
    // Skip over chunk size, offset, and blocksize fields
    if( fseek( fd, 12, SEEK_CUR ) == -1 ) goto error;
    
    dataOffset = ftell( fd );
    byteswap = false;
    if( little_endian )
        byteswap = true;
    
    return true;
    
error:
    fprintf( stderr, "[mopho](via MoAudilFileIn): error reading AIFF file( %s ).", 
            fileName );
    return false;
}

bool MoAudioFileIn::getMatInfo( const char *fileName )
{
    // verify this is a version 5 MAT-file format.
    char head[4];
    if( fseek( fd, 0, SEEK_SET ) == -1 ) goto error;
    if( fread( &head, 4, 1, fd ) != 1 ) goto error;
    // If any of the first 4 characters of the header = 0, then this is
    // a Version 4 MAT-file.
    if( strstr( head, "0" ) ) {
        fprintf( stderr, "[mopho](via MoAudilFileIn): %s appears to be a Version 4 MAT-file, not currently supported.",
                fileName );
        return false;
    }
    
    // determine the endian-ness of the file
    char mi[2];
    byteswap = false;
    // locate "M" and "I" characters in header
    if( fseek( fd, 126, SEEK_SET ) == -1 ) goto error;
    if( fread( &mi, 2, 1, fd ) != 1 ) goto error;
    if( little_endian )
    {
        if( !strncmp( mi, "MI", 2 ) )
            byteswap = true;
        else if( strncmp( mi, "IM", 2 ) ) goto error;
    }
    else
    {
        if( !strncmp( mi, "IM", 2 ) )
            byteswap = true;
        else if( strncmp( mi, "MI", 2 ) ) goto error;
    }
    
    // Check the data element type
    // SINT32 datatype;
    long datatype;
    
    if( fread( &datatype, 4, 1, fd ) != 1 ) goto error;
    if( byteswap ) swap32( (unsigned char *)&datatype );
    if( datatype != 14 ) {
        fprintf( stderr, "[mopho](via MoAudilFileIn): file does not contain a single Matlab array (or matrix) data element." );
        return false;
    }
    
    // Determine the array data type.
    // SINT32 tmp;
    long tmp;
    
    // SINT32 size;
    long size;
    
    if( fseek( fd, 168, SEEK_SET ) == -1 ) goto error;
    if( fread( &tmp, 4, 1, fd ) != 1 ) goto error;
    if( byteswap ) swap32( (unsigned char *)&tmp );
    if( tmp == 1 ) {  // array name > 4 characters
        if( fread( &tmp, 4, 1, fd ) != 1 ) goto error;  // get array name length
        if( byteswap ) swap32( (unsigned char *)&tmp );
        // size = ( SINT32 ) ceil( ( float )tmp / 8 );
        size = (long)ceil( (float)tmp / 8 );
        if( fseek( fd, size*8, SEEK_CUR ) == -1 ) goto error;  // jump over array name
    }
    else { // array name <= 4 characters, compressed data element
        if( fseek( fd, 4, SEEK_CUR ) == -1 ) goto error;
    }
    if( fread( &tmp, 4, 1, fd ) != 1 ) goto error;
    if( byteswap ) swap32( (unsigned char *)&tmp );
    if( tmp == 1 ) dataType = STK_SINT8;
    else if( tmp == 3 ) dataType = STK_SINT16;
    else if( tmp == 5 ) dataType = STK_SINT32;
    else if( tmp == 7 ) dataType = MY_FLOAT32;
    else if( tmp == 9 ) dataType = MY_FLOAT64;
    else {
        fprintf( stderr, "[mopho](via MoAudilFileIn): MAT-file array data format( %d ) not supported.", tmp );
        return false;
    }
    
    // get number of rows from the header
    // SINT32 rows;
    long rows;
    
    if( fseek( fd, 160, SEEK_SET ) == -1 ) goto error;
    if( fread( &rows, 4, 1, fd ) != 1 ) goto error;
    if( byteswap ) swap32( (unsigned char *)&rows );
    
    // get number of columns from the header
    // SINT32 columns;
    long columns;
    
    if( fread( &columns,4, 1, fd ) != 1 ) goto error;
    if( byteswap ) swap32( (unsigned char *)&columns );
    
    // assume channels = smaller of rows or columns
    if( rows < columns ) {
        channels = rows;
        fileSize = columns;
    }
    else {
        fprintf( stderr, "[mopho](via MoAudilFileIn): transpose MAT-file array so that audio channels fill matrix rows (not columns)." );
        return false;
    }
    bufferSize = fileSize;
    if( fileSize > CHUNK_THRESHOLD ) {
        chunking = true;
        bufferSize = CHUNK_SIZE;
    }
    
    // Move read pointer to the data in the file.
    // SINT32 headsize;
    long headsize;
    
    if( fseek( fd, 132, SEEK_SET ) == -1 ) goto error;
    if( fread( &headsize, 4, 1, fd ) != 1 ) goto error; // file size from 132nd byte
    if( byteswap ) swap32( (unsigned char *)&headsize );
    headsize -= fileSize * 8 * channels;
    if( fseek( fd, headsize, SEEK_CUR ) == -1 ) goto error;
    dataOffset = ftell( fd );
    
    // Assume MAT-files have 44100 Hz sample rate.
    fileRate = 44100.0;
    
    // Set default rate based on file sampling rate.
    rate = (SAMPLE)( fileRate / MoAudio::getSampleRate() );
    
    return true;
    
error:
    fprintf( stderr, "[mopho](via MoAudilFileIn): error reading MAT-file( %s ).", fileName );
    return false;
}


bool MoAudioFileIn::readData( unsigned long index )
{
    while( index <( unsigned long )chunkPointer ) {
        // negative rate
        chunkPointer -= CHUNK_SIZE;
        bufferSize = CHUNK_SIZE;
        if( chunkPointer < 0 ) {
            bufferSize += chunkPointer;
            chunkPointer = 0;
        }
    }
    while( index >= chunkPointer+bufferSize ) {
        // positive rate
        chunkPointer += CHUNK_SIZE;
        bufferSize = CHUNK_SIZE;
        if( ( unsigned long )chunkPointer+CHUNK_SIZE >= fileSize ) {
            bufferSize = fileSize - chunkPointer;
        }
    }
    
    long i, length = bufferSize;
    bool endfile =( chunkPointer+bufferSize == fileSize );
    if( !endfile ) length += 1;
    
    // read samples into data[].  Use SAMPLE data structure
    // to store samples
    if( dataType == STK_SINT16 ) {
        short * buf = (short *)data; // (SINT16 *)data;
        if( fseek( fd, dataOffset+( long )( chunkPointer*channels*2 ), SEEK_SET ) == -1 ) goto error;
        if( fread( buf, length*channels, 2, fd ) != 2 ) goto error;
        if( byteswap ) {
            // SINT16 * ptr = buf;
            short * ptr = buf;
            for( i=length*channels-1; i>=0; i-- )
                swap16( (unsigned char *)( ptr++ ) );
        }
        for( i=length*channels-1; i>=0; i-- )
            data[i] = buf[i];
    }
    else if( dataType == STK_SINT32 ) {
        // SINT32 *buf = ( SINT32 * )data;
        long * buf = (long *)data;
        
        if( fseek( fd, dataOffset+( long )( chunkPointer*channels*4 ), SEEK_SET ) == -1 ) goto error;
        if( fread( buf, length*channels, 4, fd ) != 4 ) goto error;
        if( byteswap ) {
            // SINT32 * ptr = buf;
            long * ptr = buf;
            for( i=length*channels-1; i>=0; i-- )
                swap32( (unsigned char *)( ptr++ ) );
        }
        for( i=length*channels-1; i>=0; i-- )
            data[i] = buf[i];
    }
    else if( dataType == MY_FLOAT32 ) {
        // FLOAT32 * buf = (FLOAT32 *)data;
        float * buf = (float *)data;
        
        if( fseek( fd, dataOffset+( long )( chunkPointer*channels*4 ), SEEK_SET ) == -1 ) goto error;
        if( fread( buf, length*channels, 4, fd ) != 4 ) goto error;
        if( byteswap ) {
            // FLOAT32 * ptr = buf;
            float * ptr = buf;
            for( i=length*channels-1; i>=0; i-- )
                swap32( (unsigned char *)( ptr++ ) );
        }
        for( i=length*channels-1; i>=0; i-- )
            data[i] = buf[i];
    }
    else if( dataType == MY_FLOAT64 ) {
        // FLOAT64 * buf = (FLOAT64 *)data;
        double * buf = (double *)data;
        
        if( fseek( fd, dataOffset+( long )( chunkPointer*channels*8 ), SEEK_SET ) == -1 ) goto error;
        if( fread( buf, length*channels, 8, fd ) != 8 ) goto error;
        if( byteswap ) {
            // FLOAT64 * ptr = buf;
            double * ptr = buf;
            for( i=length*channels-1; i>=0; i-- )
                swap64( (unsigned char *)( ptr++ ) );
        }
        for( i=length*channels-1; i>=0; i-- )
            data[i] = buf[i];
    }
    else if( dataType == STK_SINT8 ) {
        unsigned char *buf =(unsigned char *)data;
        if( fseek( fd, dataOffset+( long )( chunkPointer*channels ), SEEK_SET ) == -1 ) goto error;
        if( fread( buf, length*channels, 1, fd ) != 1 ) goto error;
        for( i=length*channels-1; i>=0; i-- )
            data[i] = buf[i] - 128.0;  // 8-bit WAV data is unsigned!
    }
    
    // if at end of file, repeat last sample frame for interpolation.
    if( endfile ) {
        for( unsigned int j=0; j<channels; j++ )
            data[bufferSize*channels+j] = data[( bufferSize-1 )*channels+j];
    }
    
    if( !chunking ) {
        fclose( fd );
        fd = 0;
    }
    
    return true;
    
error:
    fprintf( stderr, "[mopho](via MoAudilFileIn): error reading file data." );
    return false;
    // handleError( msg, StkError::FILE_ERROR );
}

void MoAudioFileIn::reset()
{
    time = (SAMPLE) 0.0;
    for( unsigned int i = 0; i < channels; i++ )
        lastOutput[i] = (SAMPLE) 0.0;
    finished = false;
}

void MoAudioFileIn::normalize()
{
    this->normalize( (SAMPLE) 1.0 );
}

// normalize all channels equally by the greatest magnitude in all of the data.
void MoAudioFileIn::normalize( SAMPLE peak )
{
    if( chunking ) {
        if( dataType == STK_SINT8 ) gain = peak / 128.0;
        else if( dataType == STK_SINT16 ) gain = peak / 32768.0;
        else if( dataType == STK_SINT32 ) gain = peak / 2147483648.0;
        else if( dataType == MY_FLOAT32 || dataType == MY_FLOAT64 ) gain = peak;
        
        return;
    }
    
    unsigned long i;
    SAMPLE max =(SAMPLE) 0.0;
    
    for( i=0; i<channels*bufferSize; i++ ) {
        if( fabs( data[i] ) > max )
            max =(SAMPLE) fabs( ( double ) data[i] );
    }
    
    if( max > 0.0 ) {
        max =(SAMPLE) 1.0 / max;
        max *= peak;
        for( i=0;i<=channels*bufferSize;i++ )
            data[i] *= max;
    }
}

unsigned long MoAudioFileIn::getSize() const
{
    return fileSize;
}

unsigned int MoAudioFileIn::getChannels() const
{
    return channels;
}

SAMPLE MoAudioFileIn::getFileRate() const
{
    return fileRate;
}

bool MoAudioFileIn::isFinished() const
{
    return finished;
}

void MoAudioFileIn::setRate( SAMPLE aRate )
{
    rate = aRate;
    
    // if negative rate and at beginning of sound, move pointer to end
    // of sound
    if( ( rate < 0 ) && ( time == 0.0 ) ) time += rate + fileSize;
    
    if( fmod( rate, 1.0 ) != 0.0 ) interpolate = true;
    else interpolate = false;
}

void MoAudioFileIn::addTime( SAMPLE aTime )   
{
    // add an absolute time in samples 
    time += aTime;
    
    if( time < 0.0 ) time = 0.0;
    if( time >= fileSize ) {
        time = fileSize;
        finished = true;
    }
}

void MoAudioFileIn::setInterpolate( bool doInterpolate )
{
    interpolate = doInterpolate;
}

const SAMPLE * MoAudioFileIn::lastFrame() const
{
    return lastOutput;
}

SAMPLE MoAudioFileIn::lastOut() const
{
    if( channels == 1 )
        return (*lastOutput * m_gain);
    
    SAMPLE output = 0.0;
    for( unsigned int i = 0; i < channels; i++ ) {
        output += lastOutput[i];
    }
    
    // MOPHO: added * m_gain
    return output / channels * m_gain;
}

SAMPLE MoAudioFileIn::tick()
{
    tickFrame();
    return lastOut();
}

SAMPLE * MoAudioFileIn::tick( SAMPLE * vec, unsigned int vectorSize )
{
    for( unsigned int i = 0; i < vectorSize; i++ )
        vec[i] = tick();
    
    return vec;
}

const SAMPLE * MoAudioFileIn::tickFrame()
{
    register SAMPLE tyme, alpha;
    register unsigned long i, index;
    
    if( finished ) return lastOutput;
    
    tyme = time;
    if( chunking ) {
        // check the time address vs. our current buffer limits
        if( ( tyme < chunkPointer ) ||( tyme >= chunkPointer+bufferSize ) )
            this->readData( ( long ) tyme );
        // adjust index for the current buffer
        tyme -= chunkPointer;
    }
    
    // integer part of time address
    index = ( long ) tyme;
    
    if( interpolate ) {
        // linear interpolation ... fractional part of time address
        alpha = tyme -(SAMPLE) index;
        index *= channels;
        for( i=0; i<channels; i++ ) {
            lastOutput[i] = data[index];
            lastOutput[i] +=( alpha *( data[index+channels] - lastOutput[i] ) );
            index++;
        }
    }
    else
    {
        index *= channels;
        for( i=0; i<channels; i++ )
            lastOutput[i] = data[index++];
    }
    
    if( chunking ) {
        // scale outputs by gain
        for( i=0; i<channels; i++ ) lastOutput[i] *= gain;
    }
    
    // increment time, which can be negative
    time += rate;
    if( time < 0.0 || time >= fileSize ) finished = true;
    
    return lastOutput;
}

SAMPLE * MoAudioFileIn::tickFrame( SAMPLE * frameVector, unsigned int frames )
{
    unsigned int j;
    for( unsigned int i=0; i<frames; i++ ) {
        tickFrame();
        for( j=0; j<channels; j++ )
            frameVector[i*channels+j] = lastOutput[j];
    }
    
    return frameVector;
}
