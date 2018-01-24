#!/bin/bash
cd ../gmt

topoType=cos
sourceFrequency=1000
backupfolder=../backup/$topoType\_$sourceFrequency/


./plotDeployment.sh $backupfolder
./plotSnapshot.sh $backupfolder
exit

#for shell in $( ls plot*.sh );
#do
#oldString=`grep "^gmt gmtset FONT" $shell`
#newString="gmt gmtset FONT 9p,Helvetica,black"
#newString="gmt gmtset FONT 9p,Times-Roman,black"

#sed -i "s/$oldString/$newString/g" $shell
#$shell
#done
