#!/bin/bash
source /usr/share/modules/init/bash
module load apps gmt/intel/5.1.0

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
#gmt gmtset FONT 9p,Times-Roman,black
#gmt gmtset PS_MEDIA custom_2.8ix2.8i
gmt gmtset PS_MEDIA letter
gmt gmtset PS_PAGE_ORIENTATION portrait
#gmt gmtset GMT_VERBOSE d

runningName=$1

topoType=`echo $runningName | cut -d '_'  -f1`
sourceIncidentAngle=`echo $runningName | cut -d '_'  -f2`
trace_normalization=`cat ../running/none_$sourceIncidentAngle/backup/trace_normalization`

backupfolder=../running/$runningName/backup/
figfolder=../figures/$runningName/ 
mkdir -p $figfolder

ps=$figfolder\wiggle.ps
eps=$figfolder\wiggle.eps
pdf=$figfolder\wiggle.pdf

time_resample=10
totalTrace=`cat $backupfolder\combinedTotalPressureTrace | awk -v time_resample="$time_resample" 'NR%time_resample==1{print}' `

receiver=$backupfolder\receiver_polar
receiver_range=`awk '{print 90-$1*(180/atan2(0,-1))}' $receiver`
receiver_number=`echo "$receiver_range" | cat | wc -l`
receiver_start=`echo "$receiver_range" | awk 'NR==1 {print $1}'`
receiver_end=`echo "$receiver_range" | awk 'END {print $1}'`
receiver_spacing=`echo "($receiver_end-($receiver_start)) / ($receiver_number-1)" | bc -l`

xmin=`echo "$receiver_start-$receiver_spacing" | bc -l`
xmax=`echo "$receiver_end+$receiver_spacing" | bc -l`
ymin=`echo "$totalTrace" | awk 'NR==1 {print $1}'`
ymax=`echo "$totalTrace" | awk 'END {print $1}'`
region=$xmin/$xmax/$ymin/$ymax
width=2.2
height=2.8
projection=X$width\i/$height\i
scale=`echo "0.5/($width*$receiver_spacing/($receiver_end-($receiver_start)))" | bc -l`

gmt psbasemap -R$region -J$projection -Bxa45f22.5+l"Angle (deg) " -Bya0.04f0.02+l"Time (s)" -K > $ps

col=2
for range in $receiver_range
do
echo "$totalTrace" | awk -v col="$col" -v range="$range"  -v trace_normalization="$trace_normalization" '{ print range,$1,$col/trace_normalization}' | gmt pswiggle -R -J -Z$scale -G-red -G+red -P -Wthinnest,black -O -K >> $ps
let "col++"
done
gmt psbasemap -R$region -J$projection -Bxa45f22.5+l"Angle (deg) " -Bya0.04f0.02+l"Time (s)" -O >> $ps
#gmt pslegend -R -J -D-2.5/-11.25/3i/TL -Fthick -O -K << END >> $ps
#S 0i s 0.05i 255/0/0 0.25p 0.1i 0% 
#END
#gmt pslegend -R -J -D0/-11.25/3i/TL -Fthick -O << END >> $ps
#S 0i s 0.05i 0/0/255 0.25p 0.1i 12% 
#END
#---------------------------------------------------------

gmt ps2raster -A -Te $ps -D$figfolder
epstopdf --outfile=$pdf $eps
rm -f $ps $eps 
rm -f $figfolder\ps2raster_*bb

