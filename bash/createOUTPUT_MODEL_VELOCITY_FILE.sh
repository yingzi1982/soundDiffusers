#!/bin/bash

cat ../backup/Par_file_part > ../DATA/Par_file

nx=`cut -d ' ' -f 3 ../backup/mesh_info`
nz=`cut -d ' ' -f 6 ../backup/mesh_info`

echo "nbmodels                        = 1" >> ../DATA/Par_file
echo "1 1 1.2d0 343.0d0 0.0d0 0 0 9999 9999 0 0 0 0 0 0" >> ../DATA/Par_file
echo "nbregions                       = 1" >> ../DATA/Par_file
echo "1 $nx 1  $nz  1" >> ../DATA/Par_file

oldString=`grep "^NPROC " ../DATA/Par_file`
newString='NPROC                           = 1'
sed -i "s/$oldString/$newString/g" ../DATA/Par_file

oldString=`grep "^NSTEP " ../DATA/Par_file`
newString='NSTEP                              = 10'
sed -i "s/$oldString/$newString/g" ../DATA/Par_file

cd ../

./xmeshfem2D > OUTPUT_FILES/meshfem.log
./xspecfem2D > OUTPUT_FILES/specfem.log

mv ./DATA/proc000000_rho_vp_vs.dat ./backup/proc000000_rho_vp_vs.dat.serial
