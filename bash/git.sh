#!/bin/bash
source /usr/share/modules/init/bash
module load dev git/intel/2.2.1
#http://blog.csdn.net/sinat_20177327/article/details/76062030
#http://kbroman.org/github_tutorial/pages/init.html

operation=$1
#folder=$2
folder="../DATA.tar.gz ../bash/*sh ../figures ../gmt/*cpt ../gmt/*sh ../octave/*m ../pbs/*pbs ../backup/Par_file_part"

if [ $operation == 'push' ]
then
git add $folder
git commit -m "pushing $folder"
git push origin master
elif [ $operation == 'pull' ]
then
git commit -m "pulling"
git pull origin master
fi
