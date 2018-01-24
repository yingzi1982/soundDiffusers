#!/bin/bash
echo  'please make sure that you have enough memory, interactive pbs mode is recommended!'

oldString=`grep "^SAVE_MODEL" ../backup/Par_file_part`
newString='SAVE_MODEL                      = ascii'
sed -i "s/$oldString/$newString/g" ../DATA/Par_file

./createOUTPUT_MODEL_VELOCITY_FILE.sh


source /usr/share/modules/init/bash
module load apps octave/intel/3.6.4
cd ../octave

./generateModelsAndRegions.m
module unload apps octave/intel/3.6.4

cd ../bash
./createTOMO.sh

cat ../backup/Par_file_part ../backup/models ../backup/regions > ../DATA/Par_file

oldString=`grep "^SAVE_MODEL" ../DATA/Par_file`
newString='SAVE_MODEL                      = default'
sed -i "s/$oldString/$newString/g" ../DATA/Par_file
