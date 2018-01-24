#!/usr/bin/env octave

clear all
close all
clc

input = input('Please input the step: ','s')
step = input;

[nt_status nt] = system('grep ^nt ../backup/Par_file_part | cut -d = -f 2');

fid=fopen(['../DATA/STATIONS']);
  c=textscan(fid,'%s %s %f %f %f %f');
fclose(fid);
stationNumber=length(c{1,1});

band='BX';
variable='semd';

[p_sv_status p_sv] = system('grep p_sv ../backup/Par_file_part | cut -d = -f 2');
p_sv = strtrim(p_sv);

switch p_sv
case '.true.'
cd ../bash
system(['./combineTrace.sh' ' ' step ' ' band ' ' 'X' ' ' variable ' ' '1' ' ' '1' ' ' nt])
system(['./combineTrace.sh' ' ' step ' ' band ' ' 'Z' ' ' variable ' ' '1' ' ' '1' ' ' nt])
case '.false.'
cd ../bash
system(['./combineTrace.sh' ' ' step ' ' band ' ' 'Y' ' ' variable ' ' '1' ' ' '1' ' ' nt])
otherwise
error('Wrong p_sv type.')
end
