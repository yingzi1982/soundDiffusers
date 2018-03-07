#!/bin/bash
cd ../gmt

for topoType in flat sine triangle rectangle skyline gaussian exponential vonkarman; do
for sourceIncidentAngle in 0 30; do
running=$topoType\_$sourceIncidentAngle
./plotDeployment.sh $running
./plotSourceSignal.sh $running
./plotTraceImage.sh $running combinedTotalPressureTrace_image
./plotTraceImage.sh $running combinedScatteredPressureTrace_image
./plotPolarResponse.sh $running
done
done
./plotDiffusionCoefficient.sh
