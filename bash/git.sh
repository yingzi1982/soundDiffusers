#!/bin/bash
#http://blog.csdn.net/sinat_20177327/article/details/76062030
#http://kbroman.org/github_tutorial/pages/init.html



#create a new repository on the command line

#echo "# temp" >> README.md
#git init
#git add README.md
#git remote add origin https://github.com/yingzi1982/temp.git
uploadFolder=$1

git add $uploadFolder
git commit -m "add new files in $uploadFolder..."
git push origin master
git pull origin master
