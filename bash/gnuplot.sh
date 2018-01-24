#!/bin/bash
#rm ../figures/*.eps
source /usr/share/modules/init/bash

module load apps gnuplot/intel/4.6.4
cd ../gnuplot
./plotSource.gnu
#./plotTOMO.gnu | gnuplot
p_sv='.false.'
if [ $p_sv == '.true.' ];
then
#./plotPSVTOMO.gnu
./plotPSVMultiForwardWavefield.gnu
./plotPSVMultiBackwardWavefield.gnu
./plotPSVMultiSignal.gnu
#sed -e 's/colNum =/colNum = 3/g' ./plotPSVMultiKernel.gnu | gnuplot
#sed -e 's/colNum =/colNum = 4/g' ./plotPSVMultiKernel.gnu | gnuplot
#sed -e 's/colNum =/colNum = 5/g' ./plotPSVMultiKernel.gnu | gnuplot
#sed -e 's/colNum =/colNum = 6/g' ./plotPSVMultiKernel.gnu | gnuplot
#sed -e 's/colNum =/colNum = 7/g' ./plotPSVMultiKernel.gnu | gnuplot
#sed -e 's/colNum =/colNum = 8/g' ./plotPSVMultiKernel.gnu | gnuplot
./plotPSVMultiImage.gnu
cd ../bash
convertFigure.sh '../psv/figures/'
elif [ $p_sv == '.false.' ];
then
#./plotSHTOMO.gnu
./plotSHMultiForwardWavefield.gnu
./plotSHMultiBackwardWavefield.gnu
./plotSHMultiSignal.gnu
#sed -e 's/colNum =/colNum = 3/g' ./plotSHMultiKernel.gnu | gnuplot
#sed -e 's/colNum =/colNum = 5/g' ./plotSHMultiKernel.gnu | gnuplot
#sed -e 's/colNum =/colNum = 6/g' ./plotSHMultiKernel.gnu | gnuplot
#sed -e 's/colNum =/colNum = 8/g' ./plotSHMultiKernel.gnu | gnuplot
./plotSHMultiImage.gnu
cd ../bash
convertFigure.sh '../sh/figures/'
fi

module unload apps gnuplot/intel/4.6.4 apps
