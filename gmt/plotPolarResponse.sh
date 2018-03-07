#!/bin/bash
source /usr/share/modules/init/bash
module load apps gmt

#-------
rm gmt.conf
rm gmt.history

gmt gmtset MAP_FRAME_AXES weSN
gmt gmtset MAP_FRAME_TYPE plain
#gmt gmtset FORMAT_GEO_MAP +ddd
#gmt gmtset MAP_FRAME_PEN thick
#gmt gmtset MAP_TICK_PEN thick
#gmt gmtset MAP_TICK_LENGTH_PRIMARY -3p
#gmt gmtset MAP_DEGREE_SYMBOL none
#gmt gmtset MAP_GRID_CROSS_SIZE_PRIMARY 0.0i
#gmt gmtset MAP_GRID_CROSS_SIZE_SECONDARY 0.0i
#gmt gmtset MAP_GRID_PEN_PRIMARY thin,black
#gmt gmtset MAP_GRID_PEN_SECONDARY thin,black
gmt gmtset MAP_ORIGIN_X 100p
gmt gmtset MAP_ORIGIN_Y 100p
#gmt gmtset FORMAT_GEO_OUT +D
gmt gmtset COLOR_NAN 255/255/255
gmt gmtset COLOR_FOREGROUND 255/255/255
gmt gmtset COLOR_BACKGROUND 0/0/0
gmt gmtset COLOR_MODEL hsv
gmt gmtset FONT 12p,Helvetica,black
#gmt gmtset FONT 9p,Times-Roman,black
#gmt gmtset PS_MEDIA custom_2.8ix2.8i
gmt gmtset PS_MEDIA letter   
gmt gmtset PS_PAGE_ORIENTATION portrait
#gmt gmtset GMT_VERBOSE d

runningName=$1
backupfolder=../running/$runningName/backup/
figfolder=../figures/$runningName/ 
mkdir -p $figfolder

name=polar_response
ps=$figfolder/$name.ps
eps=$figfolder/$name.eps
pdf=$figfolder/$name.pdf


originalxy=$backupfolder$name
#xmin=`gmt gmtinfo $originalxy -C | awk '{print $1}'`
#xmax=`gmt gmtinfo $originalxy -C | awk '{print $2}'`
#ymin=`gmt gmtinfo $originalxy -C | awk '{print $3}'`
#ymax=`gmt gmtinfo $originalxy -C | awk '{print $4}'`
xmin=-90
xmax=90
ymin=0
ymax=40
region=$xmin/$xmax/$ymin/$ymax
projection=Pa2.8i

gmt psbasemap -R$region -J$projection -Bx30f15 -By$ymax\f`echo "$ymax/2" | bc -l` -K > $ps

awk -v ymax="$ymax" '{print $1, ymax+$2}' $originalxy | gmt psxy -R -J -Wthin,#FF0000 -W -K -O >> $ps
awk -v ymax="$ymax" '{print $1, ymax+$3}' $originalxy | gmt psxy -R -J -Wthin,#FF7F00 -W -K -O >> $ps
awk -v ymax="$ymax" '{print $1, ymax+$4}' $originalxy | gmt psxy -R -J -Wthin,#FFFF00 -W -K -O >> $ps
awk -v ymax="$ymax" '{print $1, ymax+$5}' $originalxy | gmt psxy -R -J -Wthin,#00FF00 -W -K -O >> $ps
awk -v ymax="$ymax" '{print $1, ymax+$6}' $originalxy | gmt psxy -R -J -Wthin,#0000FF -W -K -O >> $ps
awk -v ymax="$ymax" '{print $1, ymax+$7}' $originalxy | gmt psxy -R -J -Wthin,#4B0082 -W -K -O >> $ps
awk -v ymax="$ymax" '{print $1, ymax+$8}' $originalxy | gmt psxy -R -J -Wthin,#9400D3 -W -K -O >> $ps
awk -v ymax="$ymax" '{print $1, ymax+$9}' $originalxy | gmt psxy -R -J -Wthin,#808080 -W -K -O >> $ps

pstext -J -O -K -N -R << END >> $ps
95 40 0dB
100 20 -20dB
180 3.5 -40dB
END

gmt pslegend -R -J -D90/50/1i/BL -O << END >> $ps
S 0i s 0.05i #FF0000 0.25p 0.1i 125
S 0i s 0.05i #FF7F00 0.25p 0.1i 250
S 0i s 0.05i #FFFF00 0.25p 0.1i 500
S 0i s 0.05i #00FF00 0.25p 0.1i 1000
S 0i s 0.05i #0000FF 0.25p 0.1i 2000
S 0i s 0.05i #4B0082 0.25p 0.1i 4000
S 0i s 0.05i #9400D3 0.25p 0.1i 8000
S 0i s 0.05i #808080 0.25p 0.1i 16000
T Hz
END


gmt ps2raster -A -Te $ps -D$figfolder
epstopdf --outfile=$pdf $eps
rm -f $ps $eps
rm -f $figfolder/ps2raster_*bb
