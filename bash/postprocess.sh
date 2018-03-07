#!/bin/bash
source /usr/share/modules/init/bash
module load apps octave


for topoType in "none" "flat" "sine" "triangle" "rectangle" "skyline" "gaussian" "exponential" "vonkarman"; do
for sourceIncidentAngle in 0 30; do
#running=$topoType\_$sourceIncidentAngle
#runningOUTPUT_FILESFolder=$runningFolder/OUTPUT_FILES/
#runningBackupFolder=$runningFolder/backup/
#rm $runningOUTPUT_FILESFolder/wavefield00000*_01.txt
#mv $runningOUTPUT_FILESFolder/wavefield*_01.txt $runningBackupFolder
#mv $runningOUTPUT_FILESFolder/wavefield_grid_for_dumps.txt $runningBackupFolder


running=$topoType\_$sourceIncidentAngle
cd ../octave
./generateCombinedPressureTrace.m $running

if [ $topoType != "none" ]; then
running=$topoType\_$sourceIncidentAngle
cd ../octave
./generateDiffusion.m $running
fi

done
done

module unload apps octave
