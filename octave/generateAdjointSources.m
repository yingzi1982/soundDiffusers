#!/usr/bin/env octave

clear all
close all
clc
[dt_status dt] = system('grep deltat ../DATA/Par_file | cut -d = -f 2');
[dt] = str2num(dt);

[p_sv_status p_sv] = system('grep p_sv ../backup/Par_file_part | cut -d = -f 2');
p_sv = strtrim(p_sv);

%cuttingTime = input('Please input cutting time: ','s')
%[cuttingTime] = str2num(cuttingTime);

fid=fopen(['../DATA/STATIONS']);
  c=textscan(fid,'%s %s %f %f %f %f');
fclose(fid);
stationNumber=length(c{1,1});

band='BX';
variable='semd';

for nStation = 1:stationNumber
  switch p_sv
  case '.true.'
  x_trace = load(['../OUTPUT_FILES/' c{1,1}{nStation} '.' c{1,2}{nStation} '.' band 'X' '.' variable]);
  z_trace = load(['../OUTPUT_FILES/' c{1,1}{nStation} '.' c{1,2}{nStation} '.' band 'Z' '.' variable]);
  t = x_trace(:,1);
  x_trace = x_trace(:,2);
  z_trace = z_trace(:,2);
  %combinedTrace = [t x_trace z_trace];
  %save("-ascii",['../backup/trace_' num2str(nStation)],'combinedTrace');

  x_velocity = diff(x_trace)/dt;
  z_velocity = diff(z_trace)/dt;
  x_velocity = [x_velocity; x_velocity(end)];
  z_velocity = [z_velocity; z_velocity(end)];
  x_acceleration = diff(x_velocity)/dt;
  z_acceleration = diff(z_velocity)/dt;
  x_acceleration = [x_acceleration; x_acceleration(end)];
  z_acceleration = [z_acceleration; z_acceleration(end)];

  %[cuttingTime cuttingTimeIndex]=findNearest(t,cuttingTime(nStation,:));
  %cut_index_number = cuttingTimeIndex(2) - cuttingTimeIndex(1) + 1;
  %appendForward = zeros(cuttingTimeIndex(1)-1,1);
  %appendBackward = zeros(length(t)-cuttingTimeIndex(2),1);

  %win = transpose(welchwin(cut_index_number));
  %win = hanning(cut_index_number);
  %cut_t = t(cuttingTimeIndex(1):cuttingTimeIndex(2));
  %cut_x_trace = x_trace(cuttingTimeIndex(1):cuttingTimeIndex(2)).*win;
  %cut_z_trace = z_trace(cuttingTimeIndex(1):cuttingTimeIndex(2)).*win;
  %combinedCuttingTrace = [cut_t cut_x_trace cut_z_trace];
  %save("-ascii",['../backup/cut_trace_' num2str(nStation)],'combinedCuttingTrace');
  %cut_x_velocity = x_velocity(cuttingTimeIndex(1):cuttingTimeIndex(2)).*win;
  %cut_z_velocity = z_velocity(cuttingTimeIndex(1):cuttingTimeIndex(2)).*win;
  %cut_x_acceleration = x_acceleration(cuttingTimeIndex(1):cuttingTimeIndex(2)).*win;
  %cut_z_acceleration = z_acceleration(cuttingTimeIndex(1):cuttingTimeIndex(2)).*win;

  %cut_x_trace = [appendForward;cut_x_trace;appendBackward];
  %cut_z_trace = [appendForward;cut_z_trace;appendBackward];
  %cut_x_velocity = [appendForward;cut_x_velocity;appendBackward];
  %cut_z_velocity = [appendForward;cut_z_velocity;appendBackward];
  %cut_x_acceleration = [appendForward;cut_x_acceleration;appendBackward];
  %cut_z_acceleration = [appendForward;cut_z_acceleration;appendBackward];

  % select all
  cut_x_trace = x_trace;
  cut_z_trace = z_trace;
  cut_x_velocity = x_velocity;
  cut_z_velocity = z_velocity;
  cut_x_acceleration = x_acceleration;
  cut_z_acceleration = z_acceleration;

  normalization_x = dt * sum(cut_x_trace.*cut_x_acceleration);
  normalization_z = dt * sum(cut_z_trace.*cut_z_acceleration);
  adjoint_x = [t cut_x_velocity/normalization_x];
  adjoint_z = [t cut_z_velocity/normalization_z];
  adjoint_y = [t zeros(size(t))];
  case '.false.'
  y_trace = load(['../OUTPUT_FILES/' c{1,1}{nStation} '.' c{1,2}{nStation} '.' band 'Y' '.' variable]);
  t = y_trace(:,1);
  y_trace = y_trace(:,2);
  y_velocity = diff(y_trace)/dt;
  y_velocity = [y_velocity; y_velocity(end)];
  y_acceleration = diff(y_velocity)/dt;
  y_acceleration = [y_acceleration; y_acceleration(end)];
  cut_y_trace = y_trace;
  cut_y_velocity = y_velocity;
  cut_y_acceleration = y_acceleration;
  normalization_y = dt * sum(cut_y_trace.*cut_y_acceleration);
  adjoint_y = [t cut_y_velocity/normalization_y];
  adjoint_x = [t zeros(size(t))];
  adjoint_z = [t zeros(size(t))];
  end

  adjointDir=['../SEM/'];
  mkdir(adjointDir);
  save("-ascii",[adjointDir c{1,1}{nStation} '.' c{1,2}{nStation} '.' band 'X' '.adj'],'adjoint_x');
  save("-ascii",[adjointDir c{1,1}{nStation} '.' c{1,2}{nStation} '.' band 'Z' '.adj'],'adjoint_z');
  save("-ascii",[adjointDir c{1,1}{nStation} '.' c{1,2}{nStation} '.' band 'Y' '.adj'],'adjoint_y');

  %combineAdjointSource = [adjoint_x adjoint_z(:,2)];
  %combineAdjointSource(:,1) = combineAdjointSource(:,1)-min(combineAdjointSource(:,1));
  %combineAdjointSource(:,2:3) = flipud(combineAdjointSource(:,2:3));
  %save("-ascii",['../backup/adjoint_' num2str(nStation)],'combineAdjointSource');
end
