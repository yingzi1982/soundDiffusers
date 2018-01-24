#!/usr/bin/env octave

clear all
close all
clc

input = input('Please input the step: ','s')
step = str2num(input);

%

switch step
case 1 % forward simulation
[nt_status nt] = system('grep ^nt ../backup/Par_file_part | cut -d = -f 2');
[dt_status dt] = system('grep ^deltat ../backup/Par_file_part | cut -d = -f 2');
[centralFreqStatus centralFreq] = system('grep f0 ../DATA/SOURCE | cut -d = -f 2');
[source_typeStatus source_type] = system('grep source_type ../DATA/SOURCE | cut -d = -f 2');
[p_sv_status p_sv] = system('grep p_sv ../backup/Par_file_part | cut -d = -f 2');

p_sv = strtrim(p_sv);
source_type=str2num(source_type);
nt=str2num(nt);
dt=str2num(dt);
centralFreq = str2num(centralFreq);

t_number_min = -floor(nt/2);
t_number_max =  floor(nt/2);
if t_number_max - t_number_min + 1 != nt
  error('Please check NSTEP!')
end
t = transpose([t_number_min:t_number_max] * dt);

[t_cut s_cut] = ricker(centralFreq, dt);
s = zeros(size(t));
[t_cut t_cutIndex]=findNearest(t,t_cut);
s(t_cutIndex) = s_cut;

%band = 0.7;
%band = 0.5;
%s = gauspuls(t,centralFreq,band);

sourceTimeFunction= [t s];

Fs=1/dt;
S = abs(fftshift(fft(s)));

frequencyEnergy=sum(abs(S).^2)/nt;

F = transpose(Fs/2*linspace(-1,1,nt));
%plot(F, abs(S))
%pause(50)
powerSpectralDensity = [F abs(S)];

save("-ascii",['../backup/sourceTimeFunction'],'sourceTimeFunction')
save("-ascii",['../backup/powerSpectralDensity'],'powerSpectralDensity')


if(strcmp(p_sv,'.true.'))
  if (source_type==1)
  source_time_function_z=s;
  source_time_function_x=zeros(size(s));
  [source_time_function_angle source_time_function_amplitude]=cart2pol(source_time_function_x,source_time_function_z);
  elseif (source_type==2) 
    source_time_function_amplitude = cumsum(s);
    source_time_function_angle = zeros(size(source_time_function_amplitude));
  end
elseif (strcmp(p_sv,'.false.'))
  source_time_function_amplitude = s;
  source_time_function_angle = zeros(size(source_time_function_amplitude));
end

case 2 % backward simulation
[p_sv_status p_sv] = system('grep p_sv ../backup/Par_file_part | cut -d = -f 2');
p_sv = strtrim(p_sv);
fid=fopen(['../DATA/STATIONS']);
  c=textscan(fid,'%s %s %f %f %f %f');
fclose(fid);
stationNumber=length(c{1,1});

band='BX';
variable='semd';

switch p_sv
case '.true.'
combinedTrace_x = [];
combinedTrace_z = [];
for nStation = 1:stationNumber
  trace_x = load(['../OUTPUT_FILES/' c{1,1}{nStation} '.' c{1,2}{nStation} '.' band 'X' '.' variable]);
  trace_z = load(['../OUTPUT_FILES/' c{1,1}{nStation} '.' c{1,2}{nStation} '.' band 'Z' '.' variable]);
  trace_x = trace_x(:,2);
  trace_z = trace_z(:,2);

  combinedTrace_x = [combinedTrace_x trace_x];
  combinedTrace_z = [combinedTrace_z trace_z];

end
combinedTrace_x = flipud(combinedTrace_x);
combinedTrace_z = flipud(combinedTrace_z);
[source_time_function_angle source_time_function_amplitude]=cart2pol(combinedTrace_x,combinedTrace_z);
case '.false.'
combinedTrace_y = [];
for nStation = 1:stationNumber
  trace_y = load(['../OUTPUT_FILES/' c{1,1}{nStation} '.' c{1,2}{nStation} '.' band 'Y' '.' variable]);
  trace_y = trace_y(:,2);

  combinedTrace_y = [combinedTrace_y trace_y];

end
combinedTrace_y = flipud(combinedTrace_y);
source_time_function_amplitude = combinedTrace_y;
source_time_function_angle = zeros(size(source_time_function_amplitude));
otherwise
error('Wrong p_sv type.')
end


otherwise
error('Wrong step type.')
end

save("-ascii",['../DATA/SOURCE_TIME_FUNCTION_ANGLE']  ,'source_time_function_angle')
save("-ascii",['../DATA/SOURCE_TIME_FUNCTION_AMPLITUDE']  ,'source_time_function_amplitude')
