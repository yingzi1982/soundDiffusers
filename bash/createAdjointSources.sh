#!/bin/bash
source /usr/share/modules/init/bash

module load apps octave
cd ../octave
./generateAdjointSources.m
module unload apps octave

