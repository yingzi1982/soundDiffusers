#!/bin/bash
source /usr/share/modules/init/bash
module load apps octave/intel/3.6.4

cd ../octave

for topoType in none flat sine triangle rectangle skyline gaussian exponential vonkarman; do
for sourceIncidentAngle in 0 30; do

running=$topoType\_$sourceIncidentAngle
echo $running | ./generateCombinedPressureTrace.m

done
done

