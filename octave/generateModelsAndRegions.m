#!/usr/bin/env octave

clear all
close all
clc

mesh_info = load('../backup/mesh_info');
xmin = mesh_info(1);
xmax = mesh_info(2);
  nx = mesh_info(3);

zmin = mesh_info(4);
zmax = mesh_info(5);
  nz = mesh_info(6);

dx = (xmax - xmin)/nx;
dz = (zmax - zmin)/nz;

[NELEM_PML_THICKNESSStatus NELEM_PML_THICKNESS] = system('grep NELEM_PML_THICKNESS ../backup/Par_file_part | cut -d = -f 2');
NELEM_PML_THICKNESS = str2num(NELEM_PML_THICKNESS);

[PML_conditionsStatus PML_conditions] = system('grep ^PML_BOUNDARY_CONDITIONS ../backup/Par_file_part | cut -d = -f 2');
quasi_gypsum_length_x = dx*(NELEM_PML_THICKNESS+1);
quasi_gypsum_length_z = dz*(NELEM_PML_THICKNESS+1);

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

[topo_spatial_sampling_x topo_spatial_sampling_x_index] = findNearest(topo(:,1),spatial_sampling(:,1));
[backTopo_spatial_sampling_x backTopo_spatial_sampling_x_index] = findNearest(backTopo(:,1),spatial_sampling(:,1));

gypsum_region_indices = find( spatial_sampling(:,1) >= topo_xmin &...
                              spatial_sampling(:,1) <= topo_xmax &...
                              spatial_sampling(:,2) <= topo(topo_spatial_sampling_x_index,2) & ...
                              spatial_sampling(:,2) > backTopo(backTopo_spatial_sampling_x_index,2));

quasi_gypsum_region_indices = gypsum_region_indices(find(spatial_sampling(gypsum_region_indices,1) <= xmin+quasi_gypsum_length_x |...
			                                 spatial_sampling(gypsum_region_indices,1) >= xmax-quasi_gypsum_length_x |...
                                                         spatial_sampling(gypsum_region_indices,2) <= zmin+quasi_gypsum_length_z |...
                                                         spatial_sampling(gypsum_region_indices,2) >= zmax-quasi_gypsum_length_z));

regions(:,5) = 1;
regions(gypsum_region_indices,5) = 2;
if strcmp (strtrim(PML_conditions), '.true.')
   regions(quasi_gypsum_region_indices,5) = 3;
end

for iz = [1:nz]
  for ix = [1:nx]
    iregion = (iz-1)*nx + ix;
    regions(iregion,1:end-1) = [ix ix iz iz];
  end
end

fileID = fopen(['../backup/regions'],'w');
fprintf(fileID, '\n')
fprintf(fileID, '#------------------------------------------------------------\n')
fprintf(fileID, 'nbregions                        = %i\n',nbregions)
fprintf(fileID, '#------------------------------------------------------------\n')
for iregion = [1:nbregions]
  fprintf(fileID, '%i %i %i %i %i\n', ...
 regions(iregion,1), regions(iregion,2), regions(iregion,3), regions(iregion,4), regions(iregion,5))
end       
fprintf(fileID, '\n')
fclose(fileID);

%lambda0 = airModel(4)/f0;
%save('-ascii','../backup/lambda','lambda0')

