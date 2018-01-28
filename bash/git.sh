#!/bin/bash
#http://blog.csdn.net/sinat_20177327/article/details/76062030
#http://kbroman.org/github_tutorial/pages/init.html

operation=$1
#folder=$2
folder="../bash ../figures ../fortran ../gmt ../gnuplot ../latex ../octave ../pbs"

if [ $operation == 'push' ]
then
git add $folder
git commit -m "backup the whole system..."
git push origin master
elif [ $operation == 'pull' ]
then
echo "pull from repo"
git pull origin master
fi
