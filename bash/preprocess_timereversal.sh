#!/bin/bash
step=$1
stdpercentage=$2
p_sv=$3

echo ">>preprocessing"
source /usr/share/modules/init/bash

module load apps octave/intel/3.6.4
cd ../octave
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

if [ $step -eq 1 ];
then

cd ../octave
echo $step | ./generateSTATIONS.m
echo "STATIONS created"

echo $step | ./generateSOURCE.m
cp ../DATA/STATIONS ../backup
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

oldString=`grep "^NSTEP_BETWEEN_OUTPUT_WAVE_DUMPS" ../DATA/Par_file`
newString="NSTEP_BETWEEN_OUTPUT_WAVE_DUMPS = 35000"
sed -i "s/$oldString/$newString/g" ../DATA/Par_file

elif [ $step -eq 2 ];
then

cd ../octave
echo $step | ./generateSOURCE_TIME_FUNCTION.m
echo "SOURCE_TIME_FUNCTION created"

imaging='.false.'
if [ $imaging == '.true.' ];
then
./generateTopography.m
echo "topography and slice created"

./generateInterfaces.m
echo "interfaces created"
echo $stdpercentage | ./generateRandomField.m
cd ../bash
./createPar_file.sh

echo $step | ./generateSTATIONS.m
echo "STATIONS created"
fi

cd ../octave
echo $step | ./generateSOURCE.m
echo "SOURCE created"

sourceNumber=`wc -l ../DATA/STATIONS | cut -d ' ' -f 1`

oldString=`grep "^NSOURCES" ../DATA/Par_file`
newString="NSOURCES                        = $sourceNumber"
sed -i "s/$oldString/$newString/g" ../DATA/Par_file

oldString=`grep "^NSTEP_BETWEEN_OUTPUT_WAVE_DUMPS" ../DATA/Par_file`
newString="NSTEP_BETWEEN_OUTPUT_WAVE_DUMPS = 30001"
sed -i "s/$oldString/$newString/g" ../DATA/Par_file
fi
module unload apps octave/intel/3.6.4
echo "preprocessed"
