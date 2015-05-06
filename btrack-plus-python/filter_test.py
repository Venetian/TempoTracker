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


x = np.zeros(128)
PI = 3.1415926535897;

for n in range(len(x)):
    x[n] = np.sin(2*PI*(float(n)/float(len(x)))*3)


BUFFER_LEN = len(x)

ratio = 512/BUFFER_LEN
            
frac_1 = 1.0/float(ratio)
           
df512 = np.zeros(512)
n = 0
for i in range(BUFFER_LEN):
    df512[n] = x[i];
    for k in range(1,ratio):
        frac_2 = k*frac_1;
        if (i < BUFFER_LEN-1):
            df512[n+k] = x[i]*(1-frac_2) + (x[i+1]*frac_2);
        else:
            df512[n+k] = x[i]*(1-frac_2) + ((x[i]+(x[i]-x[i-1]))*frac_2)


    n = n+ratio
        #for k in range(1,ratio):
        #    
    
plt.subplot(211)
plt.plot(x)
plt.xlim(0,len(x))
plt.subplot(212)
plt.plot(df512)
plt.xlim(0,len(df512))
plt.show()