#!/usr/bin/env octave

clear all
close all
clc

input = input('Please input std percentage value','s')
stdPercentage = str2num(input)/100;
meanVal = 3000;

[centralFreqStatus centralFreq] = system('grep f0 ../DATA/SOURCE| cut -d = -f 2');
centralFreq = str2num(centralFreq);

[xminStatus xmin] = system('grep xmin ../backup/Par_file_part | cut -d = -f 2');
xmin = str2num(xmin);
[xmaxStatus xmax] = system('grep xmax ../backup/Par_file_part | cut -d = -f 2');
xmax = str2num(xmax);
[nxStatus nx] = system('grep nx ../backup/Par_file_part | cut -d = -f 2');
nx = str2num(nx);
xi_spacing = (xmax - xmin)/nx;
xi = [xmin-1*xi_spacing:xi_spacing:xmax+1*xi_spacing];

gamma = xi;


tomoType = 'von';
[random_X random_Z] = meshgrid(xi,gamma);
%seed = 58;
seed = 68;
centralLambda = meanVal/centralFreq;
%correlationLength = centralLambda/2;
%correlationLength = centralLambda/3;
correlationLength = centralLambda*10;
stdVal = meanVal*stdPercentage;
hurstNumber = 0.2;
[random_V]=randomField2D(tomoType,seed,random_X,random_Z,correlationLength,meanVal,stdVal,hurstNumber);
random_V = random_V - meanVal;


random_X =  permute(random_X, [2 1 3]);
random_Z =  permute(random_Z, [2 1 3]);
random_V = permute(random_V, [2 1 3]);

random_X = random_X(:); 
random_Z = random_Z(:); 
random_V = random_V(:);

random = [random_X random_Z random_V];

save('-ascii','../backup/random','random');
save('-ascii','../backup/lambda','centralLambda')
