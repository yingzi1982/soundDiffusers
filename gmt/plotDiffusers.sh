#!/bin/bash
source /usr/share/modules/init/bash
module load apps gmt

rm gmt.conf
rm gmt.history

gmt gmtset MAP_FRAME_AXES E
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

#flat sine triangle rectangle skyline gaussian exponential vonkarman
figfolder=../figures/
mkdir -p $figfolder

name=diffusers
ps=$figfolder$name.ps
eps=$figfolder$name.eps
pdf=$figfolder$name.pdf

xmin=-1
xmax=1
ymin=-0.1
ymax=5

width=1.3
height=`echo "$width*(($ymax)-($ymin))/(($xmax)-($xmin))" | bc -l`
projection=X$width\i/$height\i
offset=`echo "$width*(1.3/(($xmax)-($xmin)))" | bc -l`

region=$xmin/$xmax/$ymin/$ymax

gmt psbasemap -R$region -J$projection --MAP_FRAME_AXES='' -Ba1 -K > $ps

runningName=vonkarman_0
backupfolder=../running/$runningName/backup/
topo_polygon=$backupfolder\topoPolygon
cat $topo_polygon | gmt psxy -R -J -Gred -W0.5p -O -K >> $ps #-L+yt -Ggray 

runningName=exponential_0
backupfolder=../running/$runningName/backup/
topo_polygon=$backupfolder\topoPolygon
cat $topo_polygon | gmt psxy -R -J -Gred -W0.5p -Y$offset -O -K>> $ps #-L+yt -Ggray 

runningName=gaussian_0
backupfolder=../running/$runningName/backup/
topo_polygon=$backupfolder\topoPolygon
cat $topo_polygon | gmt psxy -R -J -Gred -W0.5p -Y$offset -O -K>> $ps #-L+yt -Ggray 

runningName=skyline_0
backupfolder=../running/$runningName/backup/
topo_polygon=$backupfolder\topoPolygon
cat $topo_polygon | gmt psxy -R -J -Gred -W0.5p -Y$offset -O -K>> $ps #-L+yt -Ggray 

runningName=rectangle_0
backupfolder=../running/$runningName/backup/
topo_polygon=$backupfolder\topoPolygon
cat $topo_polygon | gmt psxy -R -J -Gred -W0.5p -Y$offset -O -K>> $ps #-L+yt -Ggray 

runningName=triangle_0
backupfolder=../running/$runningName/backup/
topo_polygon=$backupfolder\topoPolygon
cat $topo_polygon | gmt psxy -R -J -Gred -W0.5p -Y$offset -O -K>> $ps #-L+yt -Ggray 

runningName=sine_0
backupfolder=../running/$runningName/backup/
topo_polygon=$backupfolder\topoPolygon
cat $topo_polygon | gmt psxy -R -J -Gred -W0.5p -Y$offset -O -K>> $ps #-L+yt -Ggray 

runningName=flat_0
backupfolder=../running/$runningName/backup/
topo_polygon=$backupfolder\topoPolygon
cat $topo_polygon | gmt psxy -R -J -Gred -W0.5p -Y$offset -O >> $ps #-L+yt -Ggray 

gmt ps2raster -A -Te $ps -D$figfolder
epstopdf --outfile=$pdf $eps
rm -f $ps $eps
rm -f $figfolder\ps2raster_*bb
