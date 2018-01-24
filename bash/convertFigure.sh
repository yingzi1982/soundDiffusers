#!/bin/bash
folder=$1
cd $folder
for f in `ls *.eps`; do
   convert -density 400 -flatten $f ${f%.*}.jpg;
   convert -compress jpeg ${f%.*}.jpg ${f%.*}.pdf
done 
rm *.jpg

#mkdir png
#mv *.png png
