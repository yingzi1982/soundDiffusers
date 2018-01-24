#!/usr/bin/env octave

clear all
close all
clc

backupFolder=['../backup/'];
outputFolder=['../OUTPUT_FILES/'];

[node_numberStatus node_number] = system('grep nproc ../backup/Par_file_part | cut -d = -f 2');
node_number = str2num(node_number);
node_start=0;
node_step=1;
node_end=node_number - 1;

%NGLLX = 5;
%NGLLZ = NGLLX;

combinedKernel = [];
for nnode = [node_start:node_step:node_end]
  kernel1 = load([outputFolder 'proc' sprintf('%06d',nnode) '_rho_kappa_mu_kernel.dat']);
  kernel2 = load([outputFolder 'proc' sprintf('%06d',nnode) '_rhop_alpha_beta_kernel.dat']);
  %kernel = [kernel1(round((1+NGLLX*NGLLZ)/2):NGLLX*NGLLZ:end,:) kernel2(round((1+NGLLX*NGLLZ)/2):NGLLX*NGLLZ:end,3:5)];
  %kernel = [kernel1(sort([7:25:end 9:25:end 17:25:end 19:25:end]),:) ...
  %          kernel2(sort([7:25:end 9:25:end 17:25:end 19:25:end]),3:5)];
  kernel = [kernel1(:,:) kernel2(:,3:5)];
  combinedKernel = [combinedKernel;kernel];
end
normalizationIndices = find(combinedKernel(:,2) >= -3000 & combinedKernel(:,2) <= 3000);
normalization = [max(abs(combinedKernel(normalizationIndices,3))) max(abs(combinedKernel(normalizationIndices,4))) ...
                 max(abs(combinedKernel(normalizationIndices,5))) max(abs(combinedKernel(normalizationIndices,6))) ...
                 max(abs(combinedKernel(normalizationIndices,7))) max(abs(combinedKernel(normalizationIndices,8)))];
%normalization = 10.^ceil(log10(normalization))
%combinedKernel(:,3:8) = combinedKernel(:,3:8)./normalization;
save('-ascii', [backupFolder 'normalization'], 'normalization')
save('-ascii', [backupFolder 'kernel.xyz'], 'combinedKernel')

