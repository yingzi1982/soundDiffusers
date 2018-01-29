#!/bin/bash
cd ../gmt

#topoType=flat
#sourceFrequency=1000


for topoType in  flat cos triangle rectangle gauss ; do
#for topoType in  triangle ; do

for sourceFrequency in 200 1000 5000; do
backup=$topoType\_$sourceFrequency

#./plotDeployment.sh $backup
./plotSignal.sh $backup
#./plotSnapshot.sh $backup

done 
done

#for shell in $( ls plot*.sh );
#do
#oldString=`grep "^gmt gmtset FONT" $shell`
#newString="gmt gmtset FONT 9p,Helvetica,black"
#newString="gmt gmtset FONT 9p,Times-Roman,black"

#sed -i "s/$oldString/$newString/g" $shell
#$shell
#done
