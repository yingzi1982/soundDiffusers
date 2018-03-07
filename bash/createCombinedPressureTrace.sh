#!/bin/bash
source /usr/share/modules/init/bash
module load apps octave

cd ../octave

for topoType in none flat sine triangle rectangle skyline gaussian exponential vonkarman; do
for sourceIncidentAngle in 0 30; do
running=$topoType\_$sourceIncidentAngle

./generateCombinedPressureTrace.m $running
./generateDiffusion.m $running

done
done

module unload apps octave
