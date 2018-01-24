#!/usr/bin/env octave

clear all
close all
clc
colormap = load('../gnuplot/colormap.gpf');
colormap = colormap(:,2:end);
colormapNumber = rows(colormap);

separation = [0 0.5 1];
layerNumber = [31 1];
if (colormapNumber ~= 2*sum(layerNumber) && length(separation)~=length(layerNumber)+1)
 error('Please check separation and layer number!')
end
subSeparation =[];
for i = 1:length(layerNumber)
  iSeparation = transpose(linspace(separation(i),separation(i+1),layerNumber(i)));
  subSeparation = [subSeparation;iSeparation];
end

subSeparation = [flipud(subSeparation); -subSeparation];
subSeparation = subSeparation - max(subSeparation);
subSeparation = subSeparation/min(subSeparation);

colormap = [subSeparation colormap];

save('-ascii','../gnuplot/colormap_nonlinear.gpf','colormap')
