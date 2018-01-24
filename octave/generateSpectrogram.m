#!/usr/bin/env octave

clear all
close all
clc

signalName = input('Please input the name of signal: ','s')
signal = load(['../OUTPUT_FILES/' signalName]);

t=signal(:,1);
x=signal(:,2);

dt=t(2)-t(1)

Fs=1/dt
step=ceil(length(t)/400); % one spectral slice points
window=ceil(400);% data window points
%[S, f, t] = specgram(x,2^nextpow2(window), Fs, window,window-step);
%specgram(x,2^nextpow2(window), Fs, window,window-step);
specgram(x,2^nextpow2(window), 10000, window,window-step);
%[T F] = meshgrid(t,f);
%spectrogram=[T(:),F(:),abs(S(:))/max(abs(S(:)))];
%save('-ascii',['../OUTPUT_FILES/' signalName '.spectrogram'],'spectrogram')

