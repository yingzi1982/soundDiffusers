#!/usr/bin/env octave
clear all
close all
clc

arg_list = argv ();
if length(arg_list) > 0
  topoType = arg_list{1};
else
  topoType = input('Please input the topography type of interface: ','s');
end


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



switch topoType
case 'none'
topo = -baseThickness*ones(size(x));
case 'flat'
topo = zeros(size(x));
topo = topo - min(topo);
case 'triangle'
width=0.1;
height=0.1;
x_sparse = transpose(topo_xmin:width:topo_xmax);
topo_sparse = height*ones(size(x_sparse));
topo_sparse(1:2:end) = 0;
topo = interp1(x_sparse,topo_sparse,x,'linear');
topo = topo - min(topo);
case 'rectangle'
width=0.1;
height=0.1;
x_sparse = transpose(topo_xmin:width:topo_xmax);
topo_sparse = height*ones(size(x_sparse));
topo_sparse(1:2:end) = 0;
topo = interp1(x_sparse,topo_sparse,x,'nearest');
topo = topo - min(topo);
case 'sine'
amplitude = 0.05;
period = 0.2;
topo = amplitude*sin(2*pi/period*x-pi/4);
topo = topo - min(topo);
case 'skyline'
width=0.05;
x_sparse = transpose(topo_xmin:width:topo_xmax);
seed=18
rand('seed',18)
topo_sparse = width*randi([0,4],size(x_sparse));
topo = interp1(x_sparse,topo_sparse,x,'nearest');
topo = topo - min(topo);
case {'gaussian','gau','exponential', 'exp','vonkarman','von'}
seed=18;
correlationLength = 0.02; meanVal=0;stdVal=0.08;
topo=randomField1D(topoType,seed,x,correlationLength,meanVal,stdVal);
topo = topo - min(topo);
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
