#!/bin/bash
source /usr/share/modules/init/bash
echo  'please make sure that you have enough memory, interactive pbs mode is recommended!'

oldString=`grep "^SAVE_MODEL" ../backup/Par_file_part`
newString='SAVE_MODEL                      = ascii'
sed -i "s/$oldString/$newString/g" ../backup/Par_file_part

./createOUTPUT_MODEL_VELOCITY_FILE.sh


module load apps octave
cd ../octave
./generateModelsAndRegions.m
module unload apps octave

cd ../bash
./createTOMO.sh

cat ../backup/Par_file_part ../backup/models ../backup/regions > ../DATA/Par_file

oldString=`grep "^SAVE_MODEL" ../DATA/Par_file`
newString='SAVE_MODEL                      = default'
sed -i "s/$oldString/$newString/g" ../DATA/Par_file
