#!/bin/bash
source /usr/share/modules/init/bash
module load apps gmt/intel/5.1.0

rm gmt.conf
rm gmt.history

gmt gmtset MAP_FRAME_AXES WeSn
gmt gmtset MAP_FRAME_TYPE plain
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
gmt gmtset FONT 12p,Helvetica,black
#gmt gmtset FONT 9p,Times-Roman,black
#gmt gmtset PS_MEDIA custom_2.8ix2.8i
gmt gmtset PS_MEDIA letter
gmt gmtset PS_PAGE_ORIENTATION portrait
#gmt gmtset GMT_VERBOSE d

backupName=$1
backupfolder=../backup/$backupName/
figfolder=../figures/$backupName/
mkdir -p $figfolder

lambda=`cat $backupfolder\lambda`
#scale=$lambda
scale=1


#-----------------------------------------------------
name=deployment

source=$backupfolder\source
receiver=$backupfolder\receiver
topo=$backupfolder\topo
topo_polygon=$backupfolder\topoPolygon

ps=$figfolder$name.ps
eps=$figfolder$name.eps
pdf=$figfolder$name.pdf

xmin=`awk -v scale="$scale" '{print $1/scale}' ../backup/mesh_info`
xmax=`awk -v scale="$scale" '{print $2/scale}' ../backup/mesh_info`
#ymin=`awk -v scale="$scale" '{print $4/scale}' ../backup/mesh_info`
ymin=0
ymax=`awk -v scale="$scale" '{print $5/scale}' ../backup/mesh_info`

width=2.2
height=`echo "$width*(($ymax)-($ymin))/(($xmax)-($xmin))" | bc -l`
projection=X$width\i/$height\i

region=$xmin/$xmax/$ymin/$ymax

awk -v scale="$scale" '{ print $1/scale, $2/scale }' $topo_polygon | gmt psxy -R$region -J$projection  -Bxa5f2.5+l"Cross range (m) " -Bya5f2.5+l"Range (m)" -Gred -W0.5p -K > $ps #-L+yt -Ggray 
awk -v scale="$scale" '{ print $1/scale, $2/scale }' $source   | gmt psxy -R -J -Sa0.05i -Gred  -N -Wthinner,black -O -K >> $ps
awk -v scale="$scale" '{ print $1/scale, $2/scale }' $receiver | gmt psxy -R -J -Sc0.02i -Gblue -N -Wthinner,black -O    >> $ps


gmt ps2raster -A -Te $ps -D$figfolder
epstopdf --outfile=$pdf $eps
rm -f $ps $eps
rm -f $figfolder\ps2raster_*bb
