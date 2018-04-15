#!/bin/bash
source /usr/share/modules/init/bash
module load apps gmt

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
traceName=$2

topoType=`echo $runningName | cut -d '_'  -f1`
sourceIncidentAngle=`echo $runningName | cut -d '_'  -f2`

backupfolder=../running/$runningName/backup/
figfolder=../figures/$runningName/ 
mkdir -p $figfolder

ps=$figfolder$traceName.ps
eps=$figfolder$traceName.eps
pdf=$figfolder$traceName.pdf

time_resample=1
trace=`cat $backupfolder$traceName | awk -v time_resample="$time_resample" '(NR-1)%time_resample==0{print}' `

source=$backupfolder\source
receiver=$backupfolder\receiver
station_resample_rate=20
#source_z=`cat $source | awk '{print $2}'`
receiver_z=`awk -v station_resample_rate="$station_resample_rate" '(NR-1)%station_resample_rate==0{ print $2}' $receiver`

receiver_spacing=0.999

nt=`echo "$trace" | wc -l`

xmin=`echo "$trace" | awk 'NR==1 {print $1}'`
xmax=`echo "$trace" | awk -v nt="$nt" 'NR==nt/2 {print $1}'`
ymin=`echo "$receiver_z" | awk -v receiver_spacing="$receiver_spacing" 'END {print $1-receiver_spacing}'`
ymax=`echo "$receiver_z" | awk -v receiver_spacing="$receiver_spacing" 'NR==1 {print $1+receiver_spacing}'`
region=$xmin/$xmax/$ymin/$ymax
width=2.2
height=2.8
projection=X$width\i/$height\i
scale=`echo "2/($receiver_spacing)" | bc -l`

gmt psbasemap -R$region -J$projection -Bxa0.05f0.025+l"Time (s) " -Bya1+l"Range (m)" -K > $ps

col=2
for range in $receiver_z
do
echo "$trace" | awk -v col="$col" -v range="$range"  '{ print $1,range+$col}' | gmt psxy -R -J -Gred -W1p,black -O -K >> $ps #-G-red -G+red 
let "col++"
done
gmt psbasemap -R -J -B --MAP_FRAME_AXES='' -O >> $ps
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

