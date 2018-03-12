#!/usr/bin/env octave
%https://en.wikibooks.org/wiki/Engineering_Acoustics/Outdoor_Sound_Propagation

clear all
close all
clc

f = [62.5 125 250 500 1000 2000 4000 8000];
%a = [0.123 0.445 1.32 2.73 4.66	9.86 29.4 104]/1000;  %attenuation measured at 20deg, 50%humidity, in dB per m 
%a = [0.192 0.615 1.42 2.52 5.01	14.1 48.5 166]/1000;  %attenuation measured at 20deg, 30%humidity, in dB per m 
a = [0.260 0.712 1.39 2.60 6.53 21.5 74.1 215]/1000;  %attenuation measured at 20deg, 20%humidity, in dB per m 


c = 343;

omega = 2*pi*f;

Q = 1./(2*c*a./omega)
plot(f,Q)
