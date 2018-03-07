#!/bin/bash
echo ">>interactive PBS mode"
qsub -I -A ucd01 -V -l walltime=0:59:00,nodes=1:ppn=24
