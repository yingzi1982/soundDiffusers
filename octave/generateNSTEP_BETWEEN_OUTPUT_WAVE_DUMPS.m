#!/usr/bin/env octave

clear all
close all
clc

source=load('../OUTPUT_FILES/source.txt');

source_t = source(:,1);
source_x = source(:,2);
source_z = source(:,3);

nt = length(source_t);

[minValue minIndices] = min(source_x);

NSTEP_BETWEEN_OUTPUT_WAVE_DUMPS = nt - minIndices + 1;

[oldStringStatus oldString] = system('grep "^NSTEP_BETWEEN_OUTPUT_WAVE_DUMPS"  ../DATA/Par_file');
oldString = strtrim(oldString);
newString = ['NSTEP_BETWEEN_OUTPUT_WAVE_DUMPS = ' int2str(NSTEP_BETWEEN_OUTPUT_WAVE_DUMPS)];
[status] = system(['sed -i "s/' oldString '/' newString '/g" ../DATA/Par_file']);

