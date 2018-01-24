#!/bin/bash
source /usr/share/modules/init/bash

module load apps octave/intel/3.6.4
cd ../octave
./generateAdjointSources.m
module unload apps octave/intel/3.6.4

