#!/bin/bash
source /usr/share/modules/init/bash
module load dev intel/2013-sp1-u3

# configure
echo ">>configuring"
currentdir=`pwd`
cd $currentdir
cd ../../../

./configure CC=icc FC=ifort MPIFC=mpiifort --with-mpi > configure.log

cd $currentdir
#cp -f ../fortran/constants.h ../../../setup/
#cp -f ../fortran/specfem2D.F90 ../../../src/specfem2D/
#cp -f ../fortran/prepare_source_time_function.f90 ../../../src/specfem2D/
#echo "configured and initialized" 

# make
echo ">>making executables"
cd $currentdir
cd ../../../
make clean > making.log
echo "made clean" 
make xmeshfem2D >> making.log
echo "made xmeshfem2D"
make xspecfem2D >> making.log
echo "made xspecfem2D"

# link
echo ">>coping executables"
cd $currentdir
cd ../
cp -f ../../bin/xmeshfem2D ./
echo "linked xmeshfem2D"
cp -f ../../bin/xspecfem2D ./
echo "linked xspecfem2D"

module unload dev intel/2017-u3
