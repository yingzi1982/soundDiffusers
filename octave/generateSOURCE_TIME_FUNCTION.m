#!/usr/bin/env octave
% input the secondary derivative of the source time function and record fluid potential as pressure to eliminate numerical ripple

clear all
close all
clc

input = input('Please input the step: ','s');
step = str2num(input);

switch step
case 1 % forward simulation
[nt_status nt] = system('grep ^NSTEP\  ../backup/Par_file_part | cut -d = -f 2');
[dt_status dt] = system('grep ^DT ../backup/Par_file_part | cut -d = -f 2');
nt=str2num(nt);
dt=str2num(dt);

t = transpose([0:dt:(nt-1)*dt]);

f_start = 20;
f_end = 20000;
t_cut_duration = 0.02;
t_cut = transpose([0:dt:t_cut_duration]);
%-----------------------
s_cut = chirp (t_cut, f_start, t_cut_duration, f_end, 'linear', 90);
s_cut = s_cut.*hanning(length(s_cut));
s_cut = s_cut/max(s_cut);
%-----------------------


sourceTimeFunction= [t_cut s_cut];
save("-ascii",['../backup/sourceTimeFunction'],'sourceTimeFunction')

s = zeros(size(t));
s(1:length(s_cut)) =s_cut;
%figure
%plot(t,s)

source_signal = [t -s];
[source_file_status source_file] = system('grep ^name_of_source_file ../DATA/SOURCE | cut -d = -f 2');

save("-ascii",['../', strtrim(source_file)],'source_signal');

%figure
%plot(t_cut,s_cut)
L = length(t_cut);
nfft = 2^nextpow2(L);
S_cut = fft(s_cut,nfft);

Fs=1/dt;
f = transpose(Fs*(0:(nfft/2))/nfft);
P_cut = abs(S_cut/nfft);
sourceFrequencySpetrum =[f,P_cut(1:nfft/2+1)];
save("-ascii",['../backup/sourceFrequencySpetrum'],'sourceFrequencySpetrum')

%figure
%plot(f,P_cut(1:nfft/2+1)) 
%xlim([0,20000])

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

