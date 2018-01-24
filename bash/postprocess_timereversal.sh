#!/bin/bash
source /usr/share/modules/init/bash
echo ">>postprocessing"
step=$1
stdpercentage=$2
p_sv=$3


if [ $step -eq 1 ];
then
module load apps octave/intel/3.6.4
cd ../octave
echo 35000 | ./generateCombinedWavefield.m

echo $step | ./generateCombinedTrace.m
module unload apps octave/intel/3.6.4

elif [ $step -eq 2 ];
then
module load apps octave/intel/3.6.4
cd ../octave
echo 30001 | ./generateCombinedWavefield.m

#echo $step | ./generateCombinedTrace.m
#./generateImage.m

module unload apps octave/intel/3.6.4

cd ../


if [ $p_sv == '.true.' ];
then

#mkdir -p psv/figures
backupfolder=psv/$stdpercentage/backup

elif [ $p_sv == '.false.' ];
then
#mkdir -p sh/figures
backupfolder=sh/$stdpercentage/backup
fi

mkdir -p $backupfolder

mv backup/combinedTrace_* $backupfolder
mv backup/wavefield_* $backupfolder

#mv backup/bv $backupfolder
#mv backup/image $backupfolder
#mv backup/image_bv $backupfolder

fi
echo "preprocessed"
