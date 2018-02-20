#!/usr/bin/env octave

clear all
close all
clc

input = input('Please input the step: ','s')
step = input;

[nt_status nt] = system('grep ^nt ../backup/Par_file_part | cut -d = -f 2');
[nt] = str2num(nt);

fid=fopen(['../DATA/STATIONS']);
  c=textscan(fid,'%s %s %f %f %f %f');
fclose(fid);
stationNumber=length(c{1,1});

band='BX';
variable='semd';
resample_rate = 10;

[p_sv_status p_sv] = system('grep p_sv ../backup/Par_file_part | cut -d = -f 2');
p_sv = strtrim(p_sv);
switch p_sv
case '.true.'
combinedTrace_x = zeros((nt-1)/resample_rate+1,stationNumber);
combinedTrace_z = zeros((nt-1)/resample_rate+1,stationNumber);
for nStation = 1:stationNumber
  trace_x = load(['../OUTPUT_FILES/' c{1,1}{nStation} '.' c{1,2}{nStation} '.' band 'X' '.' variable]);
  trace_z = load(['../OUTPUT_FILES/' c{1,1}{nStation} '.' c{1,2}{nStation} '.' band 'Z' '.' variable]);
  t = trace_x(1:resample_rate:end,1);
  trace_x = trace_x(1:resample_rate:end,2);
  trace_z = trace_z(1:resample_rate:end,2);

  combinedTrace_x(:,nStation) = [trace_x];
  combinedTrace_z(:,nStation) = [trace_z];

end
t=t-min(t);
normalization = max(max(abs(combinedTrace_x(:))),max(abs(combinedTrace_z(:))));
combinedTrace_x=[t combinedTrace_x/normalization];
combinedTrace_z=[t combinedTrace_z/normalization];
save("-ascii",['../backup/combinedTrace_X_' step],'combinedTrace_x');
save("-ascii",['../backup/combinedTrace_Z_' step],'combinedTrace_z');
case '.false.'
combinedTrace_y = zeros((nt-1)/resample_rate+1,stationNumber);
for nStation = 1:stationNumber
  trace_y = load(['../OUTPUT_FILES/' c{1,1}{nStation} '.' c{1,2}{nStation} '.' band 'Y' '.' variable]);
  t = trace_y(1:resample_rate:end,1);
  trace_y = trace_y(1:resample_rate:end,2);

  combinedTrace_y(:,nStation) = [trace_y];

end
t=t-min(t);
normalization = max(abs(combinedTrace_y(:)));
combinedTrace_y=[t combinedTrace_y/normalization];
save("-ascii",['../backup/combinedTrace_Y_' step],'combinedTrace_y');
otherwise
error('Wrong p_sv type.')
end
