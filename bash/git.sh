#!/bin/bash
#http://blog.csdn.net/sinat_20177327/article/details/76062030
#http://kbroman.org/github_tutorial/pages/init.html

operation=$1

if [ $operation == 'push' ]
then
git add -u
git commit -m "add new files in $uploadFolder..."
git pull origin master
git push origin master
elif [ $operation == 'pull' ]
then
git reset --hard HEAD
git clean -f -d
git pull
fi
