#!/usr/bin/env octave

clear all
close all
clc

runningName = input('Please input the running folder name: ','s');
backup_folder = ['../running/' runningName '/backup/'];

#./generateCombinedPressureTrace.m
combinedTrace = load([backup_folder 'combinedPressureTrace']);
resample_rate = 10;
t = combinedTrace(1:resample_rate:end,1);
p = combinedTrace(1:resample_rate:end,2:end);

dt = t(2) - t(1);
Fs=1/dt;
nt = length(t);
nfft = 2^nextpow2(nt);

freq = [125 250 500 1000 2000 4000 8000];
[freq_lower, freq_upper] = octaveBand(freq,1/3);

iFreq = 1:length(freq)
P = fft(p,nfft);
end

%L = length(t_cut);
%f = transpose(Fs*(0:(nfft/2))/nfft);
%P_cut = abs(S_cut/nfft);
%sourceFrequencySpetrum =[f,P_cut(1:nfft/2+1)];
