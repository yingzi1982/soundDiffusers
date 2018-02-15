#!/usr/bin/env octave
clear all
close all
clc

topoType = input('Please input the topography type of interface: ','s');

mesh_info = load('../backup/mesh_info');
xmin = mesh_info(1);
xmax = mesh_info(2);
  nx = mesh_info(3);

dx = (xmax-xmin)/nx;

[NELEM_PML_THICKNESSStatus NELEM_PML_THICKNESS] = system('grep NELEM_PML_THICKNESS ../backup/Par_file_part | cut -d = -f 2');
NELEM_PML_THICKNESS = str2num(NELEM_PML_THICKNESS);

baseThickness = 2*NELEM_PML_THICKNESS*dx;

%win = [zeros(2*NELEM_PML_THICKNESS,1); transpose(welchwin(xNumber - 4*NELEM_PML_THICKNESS)); zeros(2*NELEM_PML_THICKNESS,1)];

topo_xmin = -1;
topo_xmax =  1;
length = topo_xmax - topo_xmin;

x = transpose([topo_xmin:dx:topo_xmax]);


correlationLength = 0.2;
amplitude = 1/4*correlationLength;

switch topoType
case 'flat'
topo = amplitude*ones(size(x));
topo = topo - min(topo);
case 'sine'
period = correlationLength;
topo = amplitude*sin(2*pi/period*x-pi/4);
topo = topo - min(topo);
case 'skyline'
width = correlationLength/2
x_sparse = [topo_xmin:width:topo_xmax];
topo_sparse = width*randi([0,4],size(x_sparse));
topo = interp1(x_sparse,topo_sparse,x,'left');
topo = topo - min(topo);
case 'none'
topo = -baseThickness*ones(size(x));
otherwise
error('Wrong topography type\n')
end

topo = [x topo];

backTopo = -baseThickness*ones(size(x));
backTopo = [x backTopo];

save('-ascii','../backup/topo','topo')
save('-ascii','../backup/backTopo','backTopo')

topoPolygon = [topo; flipud(backTopo)];

save('-ascii','../backup/topoPolygon','topoPolygon')
