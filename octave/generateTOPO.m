#!/usr/bin/env octave

clear all
close all
clc

TOPO = load('../backup/TOPO.xyz');
lon = linspace(-122.3,-122.1,401);
lat = linspace(46.1,46.3,401);

[LON LAT] = meshgrid(lon,lat);
ELEVATION = griddata(TOPO(:,1),TOPO(:,2),TOPO(:,3), LON, LAT,'linear');
save('-mat-binary','../backup/TOPO_XYZ_matlab','lon','lat','ELEVATION');

TOPO = load('../backup/TOPO.utm');

xi_center = (max(TOPO(:,1)) + min(TOPO(:,1)))/2;
eta_center = (max(TOPO(:,2)) + min(TOPO(:,2)))/2;

TOPO(:,1) = TOPO(:,1) - xi_center;
TOPO(:,2) = TOPO(:,2) - eta_center;

%xi = linspace(-20000,20000,201);
%eta = linspace(-20000,20000,201);

%[XI,ETA] = meshgrid(xi,eta);

%GAMMA = griddata(TOPO(:,1),TOPO(:,2),TOPO(:,3), XI, ETA);
%save('-ascii','../backup/TOPO_UTM','xi','eta','GAMMA');

%XI = XI(:);
%ETA = ETA(:);
%GAMMA = GAMMA(:);
%TOPO = [XI ETA GAMMA];
%save('-ascii','../backup/TOPO','TOPO');

[xminStatus xmin] = system('grep xmin ../backup/Par_file_part | cut -d = -f 2');
xmin = str2num(xmin);

[xmaxStatus xmax] = system('grep xmax ../backup/Par_file_part | cut -d = -f 2');
xmax = str2num(xmax);

[nxStatus nx] = system('grep nx ../backup/Par_file_part | cut -d = -f 2');
nx = str2num(nx);
xNumber = nx + 1;

xi_slice = linspace(xmin,xmax,xNumber);
eta_slice = 0;
[XI_SLICE,ETA_SLICE] = meshgrid(xi_slice,eta_slice);
XI_SLICE = XI_SLICE(:);
ETA_SLICE = ETA_SLICE(:);
GAMMA_SLICE = griddata(TOPO(:,1),TOPO(:,2),TOPO(:,3),XI_SLICE,ETA_SLICE);
TOPO_slice = [XI_SLICE GAMMA_SLICE];
save('-ascii','../backup/TOPO_slice','TOPO_slice');

