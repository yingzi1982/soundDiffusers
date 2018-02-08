#!/usr/bin/env octave

clear all
close all
clc

input = input('Please input the step: ','s')
input = str2num(input);
step = input(1);
incidentAngle = input(2);

[f0Status freq0] = system('grep f0_attenuation ../backup/Par_file_part | cut -d = -f 2');
freq0 = str2num(freq0);

radii = 5;
theta = deg2rad(incidentAngle);

switch step

case 1
source_surf                     = {'.false.'};
xs                              = [radii*cos(theta)];
zs                              = [radii*sin(theta)];
source_type                     = [1];
time_function_type              = [1];
name_of_source_file             = {'SOURCE_FILE'};
burst_band_width                = [0.0];
f0                              = [freq0];
tshift                          = [0.0];
anglesource                     = [0.0];
Mxx                             = [1.0];
Mzz                             = [1.0]; 
Mxz                             = [0.0];
factor                          = [1.d10];

source = [xs zs];
save('-ascii','../backup/source','source');

case 2
fid=fopen(['../DATA/STATIONS']);
  c=textscan(fid,'%s %s %f %f %f %f');
fclose(fid);

source_surf                     = {'.false.'};
xs = c{1,3};
zs = c{1,4};
source_type                     = [1]*ones(size(xs));
time_function_type              = [1]*ones(size(xs));
name_of_source_file             = {'SOURCE_FILE'};
burst_band_width                = [0.0];
f0                              = [2000]*ones(size(xs));
tshift                          = [0.0]*ones(size(xs));
anglesource                     = [0.0]*ones(size(xs));
Mxx                             = [1.0]*ones(size(xs));
Mzz                             = [1.0]*ones(size(xs)); 
Mxz                             = [0.0]*ones(size(xs));
factor                          = [1.0d10]*ones(size(xs));

otherwise
error('Wrong step!')
end

SOURCENumber = length(xs);

fileID = fopen(['../DATA/SOURCE'],'w');
for nSOURCE = [1:SOURCENumber]
  fprintf(fileID, 'source_surf        = %s\n', source_surf{nSOURCE})
  fprintf(fileID, 'xs                 = %f\n', xs(nSOURCE))
  fprintf(fileID, 'zs                 = %f\n', zs(nSOURCE))
  fprintf(fileID, 'source_type        = %i\n', source_type(nSOURCE))
  fprintf(fileID, 'time_function_type = %i\n', time_function_type(nSOURCE))
  fprintf(fileID, 'name_of_source_file= %s\n', name_of_source_file{nSOURCE})
  fprintf(fileID, 'burst_band_width   = %f\n', burst_band_width(nSOURCE))
  fprintf(fileID, 'f0                 = %f\n', f0(nSOURCE))
  fprintf(fileID, 'tshift             = %f\n', tshift(nSOURCE))
  fprintf(fileID, 'anglesource        = %f\n', anglesource(nSOURCE))
  fprintf(fileID, 'Mxx                = %f\n', Mxx(nSOURCE))
  fprintf(fileID, 'Mzz                = %f\n', Mzz(nSOURCE))
  fprintf(fileID, 'Mxz                = %f\n', Mxz(nSOURCE))
  fprintf(fileID, 'factor             = %f\n', factor(nSOURCE))
%  fprintf(fileID, '#\n')
end
fclose(fileID);
