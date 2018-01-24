#!/usr/bin/env octave

clear all
close all
clc

nt_start = input('Please input time step for combinedWavefield: ','s')
nt_start = str2num(nt_start);
[p_sv_status p_sv] = system('grep p_sv ../backup/Par_file_part | cut -d = -f 2');
p_sv = strtrim(p_sv);

backupFolder=['../backup/'];
outputFolder=['../OUTPUT_FILES/'];

simulation_type = 1;

[node_numberStatus node_number] = system('grep nproc ../backup/Par_file_part | cut -d = -f 2');
node_number = str2num(node_number);
node_start=0;
node_step=1;
node_end=node_number - 1;

nt_step = 1;
nt_end =nt_start;

for nt = [nt_start:nt_step:nt_end]
  combinedWavefield = [];
  for nnode = [node_start:node_step:node_end]
    wavefield = load([outputFolder 'wavefield' sprintf('%07d',nt) '_' sprintf('%02d',simulation_type) '_' sprintf('%03d',nnode) '.txt']);
    grid = load([outputFolder 'wavefield_grid_for_dumps_' sprintf('%03d',nnode) '.txt']);
    combinedWavefield = [combinedWavefield;[grid wavefield]];
  end
  switch p_sv
  case '.true.'
    normalization = max(max(abs(combinedWavefield(:,3))),max(abs(combinedWavefield(:,4))));
    combinedWavefield(:,[3:4]) = combinedWavefield(:,[3:4])/normalization;
  case '.false.'
    normalization = max(abs(combinedWavefield(:,3)));
    combinedWavefield(:,[3]) = combinedWavefield(:,[3])/normalization;
  otherwise
    error('wrong p_sv type!')
  end
  save('-ascii', [backupFolder 'wavefield_' num2str(nt) '.xyz'], 'combinedWavefield')
end
