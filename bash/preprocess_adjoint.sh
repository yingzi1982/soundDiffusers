#!/bin/bash
simulationType=$1
topoType=$2
#sourceFrequency=$3
sourceIncidentAngle=$3

echo ">>preprocessing"
source /usr/share/modules/init/bash
module load apps octave/intel/3.6.4

if [ $simulationType -eq 1 ];
then
#-----------------------------------------------------
cd ../octave
#oldString=`grep "^f0_attenuation" ../backup/Par_file_part`
#newString="f0_attenuation                  = $sourceFrequency"
#sed -i "s/$oldString/$newString/g" ../backup/Par_file_part

./generateInterfaces.m
echo "interfaces created"

step=1
echo $step $sourceIncidentAngle | ./generateSOURCE.m
echo "SOURCE created"

#echo $step | ./generateSOURCE_TIME_FUNCTION.m
#echo "SOURCE_TIME_FUNCTION created"

echo $topoType | ./generateTopography.m
echo "topography created"

echo $step | ./generateSTATIONS.m
cp ../DATA/STATIONS ../backup
echo "STATIONS created"
exit

cd ../bash
./createPar_file.sh
cd ../octave

#-----------------------------------------------------
oldString=`grep "^output_wavefield_dumps" ../DATA/Par_file`
newString='output_wavefield_dumps          = .true.'
sed -i "s/$oldString/$newString/g" ../DATA/Par_file

oldString=`grep "^SIMULATION_TYPE" ../DATA/Par_file`
newString='SIMULATION_TYPE                 = 1'
sed -i "s/$oldString/$newString/g" ../DATA/Par_file

oldString=`grep "^SAVE_FORWARD" ../DATA/Par_file`
newString='SAVE_FORWARD                    = .true.'
sed -i "s/$oldString/$newString/g" ../DATA/Par_file


oldString=`grep "^NSTEP_BETWEEN_OUTPUT_IMAGES " ../DATA/Par_file`
newString="NSTEP_BETWEEN_OUTPUT_IMAGES = 1000"
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
