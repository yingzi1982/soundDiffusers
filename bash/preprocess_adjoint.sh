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

echo $step | ./generateSOURCE_TIME_FUNCTION.m
echo "SOURCE_TIME_FUNCTION created"

echo $step | ./generateSTATIONS.m
cp ../DATA/STATIONS ../backup
echo "STATIONS created"

echo $topoType | ./generateTopography.m
echo "topography created"

cd ../bash
#./createPar_file.sh
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
runningFolder=../running/$topoType\_$sourceIncidentAngle
rm -r $runningFolder
mkdir $runningFolder
runningOUTPUT_FILESFolder=$runningFolder/OUTPUT_FILES/
mkdir $runningOUTPUT_FILESFolder
runningBackupFolder=$runningFolder/backup/
mkdir $runningBackupFolder
cp ../backup/sourceTimeFunction ../backup/mesh_info ../backup/source_polar ../backup/source ../backup/receiver ../backup/receiver_polar ../backup/TOMO.xyz  ../backup/topoPolygon $runningBackupFolder
cp -r ../xmeshfem2D ../xspecfem2D ../DATA/ $runningFolder
pbsFile=run.pbs
runningPbsFolder=$runningFolder/pbs/
mkdir $runningPbsFolder
cp ../pbs/$pbsFile $runningPbsFolder
cd $runningPbsFolder

oldString=`grep "^#PBS -N" $pbsFile`
newString="#PBS -N specfem2d_$topoType\_$sourceIncidentAngle"
sed -i "s/$oldString/$newString/g" $pbsFile

qsub $pbsFile
#--------------------------------------------------------

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
