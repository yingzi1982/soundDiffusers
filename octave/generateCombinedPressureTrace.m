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

disp(['generating combined pressure traces in: ', running])

runningStr = strsplit(running,'_');
topoType=runningStr{1};
sourceIncidentAngle=runningStr{2};
OUTPUT_FILES_folder = ['../running/' running '/OUTPUT_FILES/'];
backup_folder = ['../running/' running '/backup/'];
DATA_folder = ['../running/' running '/DATA/'];


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
resample_rate = 10;

[receiver_polar] = load([backup_folder 'receiver_polar']);
theta = rad2deg(pi/2 - receiver_polar(:,1));

combinedPressureTrace = zeros(nt,stationNumber);
for nStation = 1:stationNumber
  trace = load([OUTPUT_FILES_folder c{1,2}{nStation} '.' c{1,1}{nStation} '.' band '.' variable]);
  combinedPressureTrace(:,nStation) = trace(:,2);
end
t = trace(:,1) - trace(1,1);
t = t(1:resample_rate:end,:);
combinedPressureTrace = combinedPressureTrace(1:resample_rate:end,:);

if strcmp(topoType,'none')
  trace_normalization =  max(abs(combinedPressureTrace(:)));
  save("-ascii",[backup_folder 'trace_normalization'],'trace_normalization');
end

combinedTotalPressureTrace = [t combinedPressureTrace];
save("-ascii",[backup_folder 'combinedTotalPressureTrace'],'combinedTotalPressureTrace');
combinedTotalPressureTrace_image = trace2image(combinedTotalPressureTrace,300,theta);
save("-ascii",[backup_folder 'combinedTotalPressureTrace_image'],'combinedTotalPressureTrace_image');

if ~strcmp(topoType,'none')
combinedNoneTotalPressureTrace = load(['../running/' 'none_' sourceIncidentAngle '/backup/combinedTotalPressureTrace']);
combinedScatteredPressureTrace = [t combinedTotalPressureTrace(:,2:end)-combinedNoneTotalPressureTrace(:,2:end)];
save("-ascii",[backup_folder 'combinedScatteredPressureTrace'],'combinedScatteredPressureTrace');
combinedScatteredPressureTrace_image = trace2image(combinedScatteredPressureTrace,300,theta);
save("-ascii",[backup_folder 'combinedScatteredPressureTrace_image'],'combinedScatteredPressureTrace_image');
end
