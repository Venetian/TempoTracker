# setup.py
# build command : python setup.py build build_ext --inplace
from numpy.distutils.core import setup, Extension
import os, numpy

name = 'btrack_plus'
sources = ['btrack_plus_module.cpp','OnsetDetectionFunction.cpp','BTrackPlus.cpp','accFFT.cpp']

include_dirs = [
                numpy.get_include(),'/usr/local/include'
                ]

setup( name = 'BTtrack_plus',
      include_dirs = include_dirs,
      ext_modules = [Extension(name, sources,extra_link_args=['-framework Accelerate'])]
      )