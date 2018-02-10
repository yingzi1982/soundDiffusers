#!/bin/bash
source /usr/share/modules/init/bash
echo ">>postprocessing"
simulationType=$1
topoType=$2
#sourceFrequency=$3
sourceIncidentAngle=$3


if [ $simulationType -eq 1 ];
then

#module load apps octave/intel/3.6.4
#cd ../octave
#./generateAdjointSources.m
#module unload apps octave/intel/3.6.4
#backupfolder=../backup/$topoType\_$sourceFrequency\_$sourceIncidentAngle
backupfolder=../backup/$topoType\_$sourceIncidentAngle
mkdir $backupfolder

rm ../OUTPUT_FILES/wavefield00000*_01.txt
mv ../OUTPUT_FILES/wavefield*_01.txt $backupfolder
mv ../OUTPUT_FILES/wavefield_grid_for_dumps.txt $backupfolder
mv ../OUTPUT_FILES/ARRAY*.semp  $backupfolder
cp ../backup/mesh_info ../backup/source* ../backup/receiver* ../backup/topoPolygon ../backup/sourceTimeFunction $backupfolder


elif [ $simulationType -eq 3 ];
then

module load apps octave/intel/3.6.4
cd ../octave
./generateCombinedKernel.m
module unload apps octave/intel/3.6.4

cd ../

mkdir -p $backupfolder

mv backup/kernel.xyz $backupfolder
mv backup/normalization $backupfolder
mv backup/TOMO.xyz $backupfolder
mv backup/lambda $backupfolder
mv backup/source $backupfolder
mv backup/receiver $backupfolder
mv backup/sourceTimeFunction $backupfolder
mv backup/sourceTimeFunction $backupfolder

fi

echo "preprocessed"
