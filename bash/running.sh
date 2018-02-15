#!/bin/bash
source /usr/share/modules/init/bash
module load dev git/intel/2.2.1
running=$1
runningFolder=../running/$running
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
newString="#PBS -N $running"
sed -i "s/$oldString/$newString/g" $pbsFile

qsub $pbsFile

