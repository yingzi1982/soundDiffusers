#!/usr/bin/env octave

clear all
close all
clc

%[xminStatus xmin] = system('grep xmin ../backup/Par_file_part | cut -d = -f 2');
%xmin = str2num(xmin);

%[xmaxStatus xmax] = system('grep xmax ../backup/Par_file_part | cut -d = -f 2');
%xmax = str2num(xmax);


input = input('Please input the step: ','s')
step = str2num(input);
switch step
case 1

theta_station_step = deg2rad(2.5);
theta_station_gap = 2*theta_station_step;

theta_station = [pi+theta_station_gap : theta_station_step : 2*pi-theta_station_gap];
r_station = 5*ones(size(theta_station));
[xi_station, gamma_station] = pol2cart (theta_station, r_station);
networkName = 'ARRAY';
elevation_station = zeros(size(xi_station));
burial_station = zeros(size(xi_station));

receiver = [transpose(xi_station) transpose(gamma_station)];
save('-ascii','../backup/receiver','receiver')

case 2
%TOMO_slice = load('../backup/model_velocity.dat_output_serial');

%NGLLX = 5;
%NGLLZ = NGLLX;

%xi_station = TOMO_slice(round((1+NGLLX*NGLLZ)/2):NGLLX*NGLLZ:end,2);
%gamma_station = TOMO_slice(round((1+NGLLX*NGLLZ)/2):NGLLX*NGLLZ:end,3);
%station_index = find(xi_station >= -3000 & xi_station <= 3000 & gamma_station >= -8000 & gamma_station <= -2000);
%xi_station = xi_station(station_index);
%gamma_station = gamma_station(station_index);
%networkName = 'GRID';
%elevation_station = zeros(size(xi_station));
%burial_station = zeros(size(xi_station));

otherwise
error('Wrong step type!')
end

fileID = fopen(['../DATA/STATIONS'],'w');
stationNumber = length(xi_station);
for nSTATIONS = 1:stationNumber
  stationName = ['S' int2str(nSTATIONS)];
  fprintf(fileID,'%s  %s  %f  %f  %f  %f\n',stationName,networkName,xi_station(nSTATIONS),gamma_station(nSTATIONS),elevation_station(nSTATIONS),burial_station(nSTATIONS));
end
fclose(fileID);
