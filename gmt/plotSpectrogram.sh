#!/bin/bash
source /usr/share/modules/init/bash
module load apps gmt
#-------
rm gmt.conf
rm gmt.history

gmt gmtset MAP_FRAME_AXES WeSn
gmt gmtset MAP_FRAME_TYPE plain
gmt gmtset MAP_FRAME_PEN thick
gmt gmtset MAP_TICK_PEN thick
gmt gmtset MAP_TICK_LENGTH_PRIMARY -3p
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
gmt gmtset FONT 12p,Helvetica,black
#gmtset MAP_ANNOT_ORTHO snew
#gmt gmtset FONT 9p,Times-Roman,black
#gmt gmtset PS_MEDIA custom_2.8ix2.8i
gmt gmtset PS_MEDIA letter   
gmt gmtset PS_PAGE_ORIENTATION portrait
#gmt gmtset GMT_VERBOSE d

backupName=$1
backupfolder=../backup/$backupName/
figfolder=../figures/$backupName/
mkdir -p $figfolder

name=spectrogram
length=2.2i
hight=1.6i
projection=X$length/$hight
cpt=$backupfolder$name.cpt
originalxyz=$backupfolder$name
grd=$backupfolder$name.nc
ps=$figfolder$name.ps
eps=$figfolder$name.eps
pdf=$figfolder$name.pdf

xmin=`gmt gmtinfo $originalxyz -C | awk '{printf "%.5f", $1}'`
xmax=`gmt gmtinfo $originalxyz -C | awk '{printf "%.5f", $2}'`
ymin=`gmt gmtinfo $originalxyz -C | awk '{printf "%.5f", $3}'`
ymax=`gmt gmtinfo $originalxyz -C | awk '{printf "%.5f", $4}'`

nx=300
ny=300
xinc=`echo "($xmax-($xmin))/$nx" | bc -l`
yinc=`echo "($ymax-($ymin))/$ny" | bc -l`

region=$xmin/$xmax/$ymin/$ymax


cat $originalxyz | awk '{ print $1, $2, $3 }' | blockmean -R$region -I$xinc/$yinc | gmt blockmode -R$region -I$xinc/$yinc | gmt surface -R$region -I$xinc/$yinc -Ll-200 -G$grd

gmt grd2cpt $grd -Crainbow -L-200/0.0 -E100 > $cpt

gmt grdimage -R -J$projection $grd -C$cpt -Bxa0.01f0.005+l"Time (s)" -Bya4000f2000+l"Frequency (Hz)" -K > $ps #  Bya2fg2

domain=1.1i/-2.4i/1.2i/0.16ih
gmt psscale -D$domain -C$cpt -E -Bxa100f50 -By+l"dB" -O -K >> $ps

gmt gmtset MAP_FRAME_AXES wesn
name=signal
vertical_offset=$hight
originalxy=$backupfolder$name
ymin=-1
ymax=1
region=$xmin/$xmax/$ymin/$ymax
projection=X$length/0.6i
cat $originalxy | gmt psxy -J$projection -R$region -B -Y$vertical_offset -Wthin,black -O >> $ps

rm -f $grd $cpt 

gmt ps2raster -A -Te $ps -D$figfolder
epstopdf --outfile=$pdf $eps
rm -f $ps $eps
rm -f $figfolder/ps2raster_*bb
