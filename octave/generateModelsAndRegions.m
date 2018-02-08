#!/usr/bin/env octave

clear all
close all
clc

[NELEM_PML_THICKNESSStatus NELEM_PML_THICKNESS] = system('grep NELEM_PML_THICKNESS ../backup/Par_file_part | cut -d = -f 2');
NELEM_PML_THICKNESS = str2num(NELEM_PML_THICKNESS);

% generate interfaces
[xminStatus xmin] = system('grep xmin ../backup/Par_file_part | cut -d = -f 2');
xmin = str2num(xmin);

[xmaxStatus xmax] = system('grep xmax ../backup/Par_file_part | cut -d = -f 2');
xmax = str2num(xmax);

[nxStatus nx] = system('grep nx ../backup/Par_file_part | cut -d = -f 2');
nx = str2num(nx);
dx = (xmax - xmin)/nx;

quasi_gypsum_length = dx*(NELEM_PML_THICKNESS+1);
[PML_conditionsStatus PML_conditions] = system('grep ^PML_BOUNDARY_CONDITIONS ../backup/Par_file_part | cut -d = -f 2');

ymin = 0;
ymax = xmax;

%[f0Status f0] = system('grep f0 ../DATA/SOURCE | cut -d = -f 2');
%f0 = str2num(f0);

%-------------------------------------------------------------------------------------
%material properties
%http://personal.inet.fi/koti/juhladude/soundproofing.html

%model_number 1 rho Vp Vs 0 0 QKappa Qmu 0 0 0 0 0 0

airModel    =    [1 1   1.2  343.0  0.00   0 0 9999 9999 0 0 0 0 0 0];
gypsumModel =    [2 1 800.0 1700.0  980.00 0 0 9999 9999 0 0 0 0 0 0];
gypsumPMLModel = [3 1 800.0 1700.0  0.00   0 0 9999 9999 0 0 0 0 0 0];
models = [airModel;gypsumModel;gypsumPMLModel];
nbmodels = rows(models);

fileID = fopen(['../backup/models'],'w');
fprintf(fileID, '\n')
fprintf(fileID, '#------------------------------------------------------------\n')
fprintf(fileID, 'nbmodels                        = %i\n',nbmodels)
fprintf(fileID, '#------------------------------------------------------------\n')
for nmodel = [1:nbmodels]
  fprintf(fileID, '%i %i %f %f %f %i %i %i %i %i %i %i %i %i %i \n', ...
  models(nmodel,1),  models(nmodel,2),  models(nmodel,3),  models(nmodel,4),  models(nmodel,5),...
  models(nmodel,6),  models(nmodel,7),  models(nmodel,8),  models(nmodel,9),  models(nmodel,10),...
 models(nmodel,11), models(nmodel,12), models(nmodel,13), models(nmodel,14), models(nmodel,15))
end       
fprintf(fileID, '\n')
fclose(fileID);
%-------------------------------------------------------------------------------------

topo = load('../backup/topo');
backTopo = load('../backup/backTopo');

topo_xmin = topo(1,1);
topo_xmax = topo(end,1);


NGLLX = 5;
NGLLZ = NGLLX;
spatial_sampling = load('../backup/proc000000_rho_vp_vs.dat.serial');
spatial_sampling = [spatial_sampling(round((1+NGLLX*NGLLZ)/2):NGLLX*NGLLZ:end,1) spatial_sampling(round((1+NGLLX*NGLLZ)/2):NGLLX*NGLLZ:end,2)];
nbregions = rows(spatial_sampling);
regions = zeros(nbregions,5);
layer_number = nbregions/nx;

[topo_spatial_sampling_x topo_spatial_sampling_x_index] = findNearest(topo(:,1),spatial_sampling(:,1));
[backTopo_spatial_sampling_x backTopo_spatial_sampling_x_index] = findNearest(backTopo(:,1),spatial_sampling(:,1));

gypsum_region_indices = find( spatial_sampling(:,1) >= topo_xmin &...
                              spatial_sampling(:,1) <= topo_xmax &...
                              spatial_sampling(:,2) <= topo(topo_spatial_sampling_x_index,2) & ...
                              spatial_sampling(:,2) >= backTopo(backTopo_spatial_sampling_x_index,2));

quasi_gypsum_region_indices = gypsum_region_indices(find(spatial_sampling(gypsum_region_indices,1) <= xmin+quasi_gypsum_length ||...
                                                         spatial_sampling(gypsum_region_indices,1) >= xmax-quasi_gypsum_length ||...
                                                         spatial_sampling(gypsum_region_indices,2) <= ymin+quasi_gypsum_length ||...
                                                         spatial_sampling(gypsum_region_indices,2) >= ymax-quasi_gypsum_length));

regions(:,5) = 1;
regions(gypsum_region_indices,5) = 2;

if strcmp (strtrim(PML_conditions), '.true.')
   regions(quasi_gypsum_region_indices,5) = 3;
end

for ilayer = [1:layer_number]
  for ix = [1:nx]
    iregion = (ilayer-1)*nx + ix;
    regions(iregion,1:end-1) = [ix ix ilayer ilayer];
  end
end

fileID = fopen(['../backup/regions'],'w');
fprintf(fileID, '\n')
fprintf(fileID, '#------------------------------------------------------------\n')
fprintf(fileID, 'nbregions                        = %i\n',nbregions)
fprintf(fileID, '#------------------------------------------------------------\n')
for nregion = [1:nbregions]
  fprintf(fileID, '%i %i %i %i %i\n', ...
 regions(nregion,1), regions(nregion,2), regions(nregion,3), regions(nregion,4), regions(nregion,5))
end       
fprintf(fileID, '\n')
fclose(fileID);

%lambda0 = airModel(4)/f0;
%save('-ascii','../backup/lambda','lambda0')

