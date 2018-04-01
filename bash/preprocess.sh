#!/bin/bash
source /usr/share/modules/init/bash
module load apps octave

topoType=$1
sourceIncidentAngle=$2

echo ">>preprocessing"
step=1

#-----------------------------------------------------
cd ../octave
#oldString=`grep "^f0_attenuation" ../backup/Par_file_part`
#newString="f0_attenuation                  = $sourceFrequency"
#sed -i "s/$oldString/$newString/g" ../backup/Par_file_part

./generateInterfaces.m
echo "interfaces created"

./generateSOURCE.m $step $sourceIncidentAngle 
echo "SOURCE created"

./generateSOURCE_TIME_FUNCTION.m $step 
echo "SOURCE_TIME_FUNCTION created"

./generateSTATIONS.m $step 
cp ../DATA/STATIONS ../backup
echo "STATIONS created"

./generateTopography.m $topoType 
echo "topography created"

cd ../bash
./createPar_file.sh
#-----------------------------------------------------

oldString=`grep "^NSTEP_BETWEEN_OUTPUT_IMAGES " ../DATA/Par_file`
newString='NSTEP_BETWEEN_OUTPUT_IMAGES = 1000'
sed -i "s/$oldString/$newString/g" ../DATA/Par_file

oldString=`grep "^output_wavefield_dumps" ../DATA/Par_file`
newString='output_wavefield_dumps          = .true.'
sed -i "s/$oldString/$newString/g" ../DATA/Par_file

oldString=`grep "^SIMULATION_TYPE" ../DATA/Par_file`
newString='SIMULATION_TYPE                 = 1'
sed -i "s/$oldString/$newString/g" ../DATA/Par_file

oldString=`grep "^SAVE_FORWARD" ../DATA/Par_file`
newString='SAVE_FORWARD                    = .false.'
sed -i "s/$oldString/$newString/g" ../DATA/Par_file

#--------------------------------------------------------
./running.sh $topoType\_$sourceIncidentAngle
#--------------------------------------------------------

echo "preprocessed"
