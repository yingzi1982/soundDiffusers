#!/usr/bin/env octave

clear all
close all
clc
disp(['please make sure that you have enough memory, interactive pbs mode is recommended!']);

[p_sv_status p_sv] = system('grep p_sv ../backup/Par_file_part | cut -d = -f 2');
p_sv = strtrim(p_sv);

fid=fopen(['../DATA/STATIONS']);
  c=textscan(fid,'%s %s %f %f %f %f');
fclose(fid);

xs = c{1,3};
zs = c{1,4};

xs_square = linspace(min(xs),max(xs),sqrt(length(xs)));
zs_square = linspace(min(zs),max(zs),sqrt(length(xs)));
[xs_square zs_square] = meshgrid(xs_square,zs_square);

switch p_sv
case '.true.'
  component = 'Z';
case '.false.'
  component = 'Y';
otherwise
  error('wrong p_sv type!')
end

combinedTrace = load (['../backup/combinedTrace_' component '_2']);

%t = combinedTrace(:,1);
%s = combinedTrace(:,2:end);
t = combinedTrace(1:ceil(end/2),1);
s_positive = combinedTrace(ceil(end/2):end,2:end);
s_negative = flipud(combinedTrace(1:ceil(end/2),2:end));

dt = t(2) - t(1);
nt = length(t);
Fs=1/dt;
F = transpose(Fs/2*linspace(-1,1,nt));

%frange = [-40 40];
frange = [0.5 40];

[frange frange_index]=findNearest(F,frange);
F = F([frange_index(1):frange_index(2)]);

S_positive = fftshift(fft(s_positive),1);
S_positive = S_positive([frange_index(1):frange_index(2)],:);

S_negative = fftshift(fft(s_negative),1);
S_negative = S_negative([frange_index(1):frange_index(2)],:);

S = S_negative + S_positive;

f_window = [2:2:40];
%f_window = [4];
bv = zeros(size(f_window));
image = zeros(length(f_window),length(xs));
image_singleFrequency = zeros(1,length(xs));

for k = 1:length(f_window)
  for i = 1:length(F)
    for j = 1:length(F)
      if abs(F(i) - F(j)) <= f_window(k)
        image_singleFrequency = image_singleFrequency + S(i,:).*conj(S(j,:));
      end
    end
  end
  image_singleFrequency = image_singleFrequency./max(image_singleFrequency);
  image_square = griddata(xs,zs,transpose(image_singleFrequency),xs_square,zs_square);
  image_square_stability = abs(image_square);
  image_square_shapeness = abs(gradient(image_square));
  bv(k) = sum(image_square_stability(:)) + sum(image_square_shapeness(:));

  image(k,:) = image_singleFrequency;
end

bv = bv/max(bv);
[bv_min bv_min_index] = min(bv);

image = transpose(abs(image));
%image = image./max(image);
image = [xs zs image];
image_bv = [xs zs image(:,bv_min_index)];
save('-ascii','../backup/bv','bv')
save('-ascii','../backup/image','image')
save('-ascii','../backup/image_bv','image_bv')

save('-ascii','../backup/image_square','image_square')
