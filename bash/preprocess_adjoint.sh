#!/bin/bash
simulationType=$1
stdpercentage=$2
p_sv=$3

echo ">>preprocessing"
source /usr/share/modules/init/bash
module load apps octave/intel/3.6.4

if [ $p_sv == '.true.' ];
then
oldString=`grep "^p_sv" ../backup/Par_file_part`
newString="p_sv                            = .true."
sed -i "s/$oldString/$newString/g" ../backup/Par_file_part

oldString=`grep "^PML_BOUNDARY_CONDITIONS" ../backup/Par_file_part`
newString="PML_BOUNDARY_CONDITIONS         = .true."
sed -i "s/$oldString/$newString/g" ../backup/Par_file_part

oldString=`grep "^STACEY_ABSORBING_CONDITIONS" ../backup/Par_file_part`
newString="STACEY_ABSORBING_CONDITIONS     = .false."
sed -i "s/$oldString/$newString/g" ../backup/Par_file_part

elif [ $p_sv == '.false.' ];
then

oldString=`grep "^p_sv" ../backup/Par_file_part`
newString="p_sv                            = .false."
sed -i "s/$oldString/$newString/g" ../backup/Par_file_part

oldString=`grep "^PML_BOUNDARY_CONDITIONS" ../backup/Par_file_part`
newString="PML_BOUNDARY_CONDITIONS         = .false."
sed -i "s/$oldString/$newString/g" ../backup/Par_file_part

oldString=`grep "^STACEY_ABSORBING_CONDITIONS" ../backup/Par_file_part`
newString="STACEY_ABSORBING_CONDITIONS     = .true."
sed -i "s/$oldString/$newString/g" ../backup/Par_file_part

fi


if [ $simulationType -eq 1 ];
then
#-----------------------------------------------------
cd ../octave
step=1
echo $step | ./generateSOURCE.m
echo "SOURCE created"

echo $step | ./generateSOURCE_TIME_FUNCTION.m
echo "SOURCE_TIME_FUNCTION created"

#./generateTopography.m
#echo "topography and slice created"
./generateInterfaces.m
echo "interfaces created"
echo $stdpercentage | ./generateRandomField.m
cd ../bash
./createPar_file.sh
cd ../octave

echo $step | ./generateSTATIONS.m
cp ../DATA/STATIONS ../backup
echo "STATIONS created"

#-----------------------------------------------------
oldString=`grep "^output_wavefield_dumps" ../DATA/Par_file`
newString='output_wavefield_dumps          = .false.'
sed -i "s/$oldString/$newString/g" ../DATA/Par_file
oldString=`grep "^SIMULATION_TYPE" ../DATA/Par_file`
newString='SIMULATION_TYPE                 = 1'
sed -i "s/$oldString/$newString/g" ../DATA/Par_file
oldString=`grep "^SAVE_FORWARD" ../DATA/Par_file`
newString='SAVE_FORWARD                    = .true.'
sed -i "s/$oldString/$newString/g" ../DATA/Par_file

elif [ $simulationType -eq 3 ];
then
oldString=`grep "^output_wavefield_dumps" ../DATA/Par_file`
newString='output_wavefield_dumps          = .false.'
sed -i "s/$oldString/$newString/g" ../DATA/Par_file
oldString=`grep "^SIMULATION_TYPE" ../DATA/Par_file`
newString='SIMULATION_TYPE                 = 3'
sed -i "s/$oldString/$newString/g" ../DATA/Par_file
oldString=`grep "^SAVE_FORWARD" ../DATA/Par_file`
newString='SAVE_FORWARD                    = .false.'
sed -i "s/$oldString/$newString/g" ../DATA/Par_file

fi
module unload apps octave/intel/3.6.4
echo "preprocessed"
