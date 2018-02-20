#!/usr/bin/env octave

clear all
close all
clc

runningName = input('Please input the running folder name: ','s');
OUTPUT_FILES_folder = ['../running/' runningName '/OUTPUT_FILES/'];
backup_folder = ['../running/' runningName '/backup/'];
DATA_folder = ['../running/' runningName '/DATA/'];


[nt_status nt] = system(['grep ^NSTEP\  ' DATA_folder 'Par_file | cut -d = -f 2']);
[dt_status dt] = system(['grep ^DT\  ' DATA_folder 'Par_file | cut -d = -f 2']);
nt=str2num(nt);
dt=str2num(dt);

fid=fopen([DATA_folder '/STATIONS']);
  c=textscan(fid,'%s %s %f %f %f %f');
fclose(fid);
stationNumber=length(c{1,1});

band='PRE';
variable='semp';
resample_rate = 1;

combinedTrace = zeros(nt,stationNumber);
for nStation = 1:stationNumber
  trace = load([OUTPUT_FILES_folder c{1,2}{nStation} '.' c{1,1}{nStation} '.' band '.' variable]);
  combinedTrace(:,nStation) = trace(:,2);
end
t = trace(:,1) - trace(1,1);
normalization = max(abs(combinedTrace(:)));

combinedTrace=[t combinedTrace/normalization];
combinedTrace = combinedTrace(1:resample_rate:end,:);
save("-ascii",[backup_folder 'combinedTrace'],'combinedTrace');
