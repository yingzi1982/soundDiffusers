#!/bin/bash
#http://blog.csdn.net/sinat_20177327/article/details/76062030
#http://kbroman.org/github_tutorial/pages/init.html

operation=$1
folder=$2

if [ $operation == 'push' ]
then
git add $folder
git commit -m "add new files in $folder..."
git push origin master
elif [ $operation == 'pull' ]
then
git reset --hard HEAD
git clean -xffd
git pull
fi
