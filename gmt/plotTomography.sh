#!/bin/bash
source /usr/share/modules/init/bash
module load apps gmt

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

figfolder=../figures/
backupfolder=../backup/

minOldString1='(-1) sh mx'
minNewString1='(-max) sh mx'
maxOldString1='(1) sh mx'
maxNewString1='(max) sh mx'

minOldString2='(-1) bc Z'
minNewString2='(-max) bc Z'
maxOldString2='(1) bc Z'
maxNewString2='(max) bc Z'

#-----------------------------------------------------
name=TOMO
domain=1.1i/-0.6i/1.2i/0.16ih

#source=$backupfolder\source
#receiver=$backupfolder\receiver
originalxyz=$backupfolder$name.xyz
processedxyz=$backupfolder$name.xyz.processed
cpt=$backupfolder$name.cpt
grd=$backupfolder$name.nc
grad=$backupfolder$name.int.nc
ps=$figfolder$name.ps
eps=$figfolder$name.eps
pdf=$figfolder$name.pdf

xmin=`awk '{print $1}' ../backup/mesh_info`
xmax=`awk '{print $2}' ../backup/mesh_info`
ymin=`awk '{print $4}' ../backup/mesh_info`
ymax=`awk '{print $5}' ../backup/mesh_info`

width=2.2
height=`echo "$width*(($ymax)-($ymin))/(($xmax)-($xmin))" | bc -l`
projection=X$width\i/$height\i

#nx=`grep nx ../backup/Par_file_part | cut -d = -f 2`
nx=500
inc=`echo "($xmax-($xmin))/$nx" | bc -l`

#zmin=`gmt gmtinfo $originalxyz -C | awk '{print $9/1000}'`
#zmax=`gmt gmtinfo $originalxyz -C | awk '{print $10/1000}'`
zmin=0
zmax=500
zinc=`echo "($zmax-$zmin)/100" | bc -l`

region=$xmin/$xmax/$ymin/$ymax
#echo $region > $backupfolder\region
#echo $subregion > $backupfolder\subregion
#echo $inc > $backupfolder\inc

gmt makecpt -CGMT_polar.cpt -T$zmin/$zmax/$zinc -Z > $cpt

cat $originalxyz | awk '{ print $1, $2, $5 }' | blockmean -R$region -I$inc > $processedxyz
cat $processedxyz | gmt blockmean -R$region -I$inc | gmt surface -R$region -I$inc -G$grd
gmt grdgradient $grd -A15 -Ne0.75 -G$grad


#gmt grdimage -R$region -J$projection $grd -C$cpt -Bxa20f10+l"Horizontal offset (@~l@~@-s@-)" -Bya20f10+l"Vertical offset (@~l@~@-s@-)" -K > $ps #  Bya2fg2
gmt grdimage -R$region -J$projection $grd -C$cpt -Bxa5f2.5+l"Cross range (m)" -Bya5f2.5+l"Range (m)" -K > $ps #  Bya2fg2
#awk '{ print $1, $2 }' $receiver | gmt psxy -R -J -St0.05i -Gred  -N -Wthinner,black -O -K >> $ps
#awk '{ print $1, $2 }' $source   | gmt psxy -R -J -Sa0.05i -Gblue -N -Wthinner,black -O -K >> $ps

gmt psscale -D$domain -C$cpt -E -Bxa500f250 -By+l"m/s" -O >> $ps

gmt ps2raster -A -Te $figfolder$ps -D$figfolder
epstopdf --outfile=$pdf $eps
rm -f $grd $grad $cpt $processedxyz
rm -f $ps $eps
rm -f $figfolder\ps2raster_*bb
