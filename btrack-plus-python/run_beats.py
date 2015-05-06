#! /usr/bin/env python
import sys 

from scikits.audiolab import wavread
import pylab as plt
import numpy as np
import btrack_plus as btrack_plus
#import btrack as btrack
import time as time
import os, os.path
import pickle
import beat_evaluation_toolbox as be

# path to the database audio files
if (sys.argv[1] == 'anr'):
	db_path = '/Volumes/Terrasaurus/LISTENING_ROOM_ANR/ANR/hainsworthtracks/'
#	db_path = '/Users/andrew/Bitbucket/project-moon/annotations/'
	db_path_df = '/Users/andrew/Bitbucket/project-moon/annotations/'
	# path to the annotations
	anns_path = '/Users/andrew/Bitbucket/project-moon/annotations/'

elif (sys.argv[1] == 'ams'):
	db_path = '/Users/adamstark/Documents/Audio/Databases/Hainsworth/audio/'
	db_path_df = '/Users/adamstark/Documents/Audio/Databases/Hainsworth/dfs/'
	# path to the annotations
	anns_path = '/Users/adamstark/Documents/Audio/Databases/Hainsworth/annotations/'
else:
	db_path = '/Users/adamstark/Documents/Audio/Databases/Hainsworth/audio/'
	db_path_df = '/Users/adamstark/Documents/Audio/Databases/Hainsworth/dfs/'
	# path to the annotations
	anns_path = '/Users/adamstark/Documents/Audio/Databases/Hainsworth/annotations/'

dfs = pickle.load(open(db_path_df+"hainsworth.dfs","rb"))

anns = pickle.load(open(anns_path+"hainsworth.anns","rb"))

numfiles = 222 #len(os.listdir(db_path))     # get the number of audio files
print numfiles
files = os.listdir(db_path);            # get file names


#numfiles = 4                           # over write numfiles while we just test on one or two

beats = []                              # create beats as an empty list to hold beat times

tic = time.clock()                      # store start time


# print out the names of all files one by one
for i in range(numfiles):
    print (i+1), ": ", files[i], " (doing btrack plus!)"				# print number and name of file
    data, fs, enc = wavread(db_path + files[i])     # extract audio from file
    #odf = btrack_plus.onsetdf(data)                    # extract onset detection function and store in list 'df'
    #odf = btrack_plus.onsetdf(data)                    # extract onset detection function and store in list 'df'
    #odf = dfs['df_complex_sd'][i]
    #bts = btrack_plus.btrack_df(odf)
    
    bts = btrack_plus.btrack(data)
    beats.append(bts)                    # extract onset detection function and store in list 'df'
### end for

toc = time.clock()                      # store end time
print (toc - tic)                       # print time taken for processing

##################################################################
###################### EVALUATION ################################

# evaluate all beats (using all measures by default)
#be.evaluate_db(anns['beats'],beats,'all',doCI = True)

# evaluate all beats (using all measures, explicitly)
#be.evaluate_db(anns['beats'],beats,['fMeasure','cemgilAcc','gotoAcc','pScore','continuity','infoGain','amlCem'],True)

# evaluate all beats (using just some measures)
#be.evaluate_db(anns['beats'],beats,['continuity','infoGain','amlCem'])

be.evaluate_db(anns['beats'],beats,['continuity','infoGain','amlCem'],doCI = True)

##################################################################
##################################################################
##################################################################
##################################################################
