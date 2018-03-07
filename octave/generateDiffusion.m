#!/usr/bin/env octave

clear all
close all
clc

arg_list = argv ();
if length(arg_list) > 0
  running=arg_list{1};
else
  running = input('Please input the running name: ','s');
end

disp(['generating diffusion in: ', running])

runningStr = strsplit(running,'_');
topoType=runningStr{1};
sourceIncidentAngle=runningStr{2};

backup_folder = ['../running/' running '/backup/'];

%system(['./generateCombinedPressureTrace.m' running]);
combinedTrace = load([backup_folder 'combinedScatteredPressureTrace']);
resample_rate = 1;
t = combinedTrace(1:resample_rate:end,1);
trace = combinedTrace(1:resample_rate:end,2:end);

dt = t(2) - t(1);
Fs=1/dt;
nt = length(t);

[receiver_polar] = load([backup_folder 'receiver_polar']);
theta = rad2deg(pi/2 - receiver_polar(:,1));

fc = transpose([125 250 500 1000 2000 4000 8000 16000]);

[band_lower, band_upper] = octaveBand(fc,1/3);

nfft = 2^nextpow2(nt);
f = transpose(Fs*(0:(nfft/2))/nfft);

TRACE = fft(trace,nfft)/nfft;
TRACE_dB = 20*log10(abs(TRACE(1:nfft/2+1,:)));

polar_response = zeros(length(fc), length(theta));
for iFc = 1:length(fc)
  index = find(f>=band_lower(iFc) & f<=band_upper(iFc));
  polar_response(iFc,:) = mean(TRACE_dB(index,:));
end

polar_response = transpose(polar_response);
polar_response = polar_response - repmat(max(polar_response),length(theta),1);
polar_response2 = 10.^(polar_response/10);
polar_response = [theta polar_response];
save("-ascii",[backup_folder 'polar_response'],'polar_response');
diffusion_coefficient = (sum(polar_response2).^2 - sum(polar_response2.^2))./((length(theta)-1)*sum(polar_response2.^2));
diffusion_coefficient = [fc transpose(diffusion_coefficient)];
save("-ascii",[backup_folder 'diffusion_coefficient'],'diffusion_coefficient');

if ~strcmp(topoType,'flat')
diffusion_coefficient_reference = load(['../running/' 'flat_' sourceIncidentAngle '/backup/diffusion_coefficient']);
diffusion_coefficient_normalized = (diffusion_coefficient(:,2) - diffusion_coefficient_reference(:,2))./(1 - diffusion_coefficient_reference(:,2));
diffusion_coefficient_normalized = [fc diffusion_coefficient_normalized];
save("-ascii",[backup_folder 'diffusion_coefficient_normalized'],'diffusion_coefficient_normalized');
end
