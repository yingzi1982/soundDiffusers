#!/bin/bash
echo ">>submitting jobs"
cd ../pbs
qsub specfem.pbs
echo "submitted at `date`"
