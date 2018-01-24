#!/bin/bash

step=$1
band=$2
component=$3
variable=$4
startStepIndex=$5
stepLength=$6
endStepIndex=$7

cd ../fortran
gfortran combineTrace.f90 -o ../bin/combineTrace
cd ../bin
echo $1 $2 $3 $4 $5 $6 $7 | ./combineTrace
