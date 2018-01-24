#!/bin/bash
source /usr/share/modules/init/bash
module load apps octave/intel/3.6.4

cat ../backup/Par_file_part ../backup/models ../backup/regions > ../DATA/Par_file

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


cd ./octave
./generateTOMO.m
module unload apps octave/intel/3.6.4

