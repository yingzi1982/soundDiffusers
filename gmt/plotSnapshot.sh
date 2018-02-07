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

backupName=$1
backupfolder=../backup/$backupName/
figfolder=../figures/$backupName/
mkdir -p $figfolder

topo_polygon=$backupfolder\topoPolygon
source=$backupfolder\source
receiver=$backupfolder\receiver


minOldString1='(-1) sh mx'
minNewString1='(-max) sh mx'
maxOldString1='(1) sh mx'
maxNewString1='(max) sh mx'

minOldString2='(-1) bc Z'
minNewString2='(-max) bc Z'
maxOldString2='(1) bc Z'
maxNewString2='(max) bc Z'


lambda=`cat $backupfolder\lambda`
#scale=$lambda
scale=1

zmin=-1
zmax=1
zinc=`echo "($zmax-($zmin))/50" | bc -l`

cpt=$backupfolder\snapshot.cpt
gmt makecpt -CGMT_seis.cpt -T$zmin/$zmax/$zinc -Z > $cpt
domain=1.1i/-0.4i/1.2i/0.16ih


meshGridFile=$backupfolder\wavefield_grid_for_dumps.txt
snapshotNormalizationFile=$backupfolder\wavefield0050000_01.txt

xmin=`gmt gmtinfo $meshGridFile -C | awk '{print $1}'`
xmax=`gmt gmtinfo $meshGridFile -C | awk '{print $2}'`
ymin=`gmt gmtinfo $meshGridFile -C | awk '{print $3}'`
ymax=`gmt gmtinfo $meshGridFile -C | awk '{print $4}'`
offset=0.2

normalization=`paste -d ' ' $meshGridFile $snapshotNormalizationFile | awk -v offset="$offset" -v xmin="$xmin" -v xmax="$xmax" -v ymin="$ymin" -v ymax="$ymax" '{if($1>=xmin+offset && $1<=xmax-offset && $2>=ymin+offset && $2<=0){print sqrt($3^2)}}' | gmt gmtinfo -C | awk '{print $2}'` 
upperLimit=$normalization
lowerLimit=-$normalization

snapshotFile=$backupfolder\snapshot
grd=$snapshotFile.nc

projection=X2.2i/2.2i

region=$xmin/$xmax/$ymin/$ymax
nx=`grep nx ../backup/Par_file_part | cut -d = -f 2`
#nx=200
inc=`echo "($xmax-($xmin))/$nx" | bc -l`


allSnapshots=`ls $backupfolder\wavefield*_01.txt | cut -d '/' -f 4`

for iSnapshot in $allSnapshots;
do

ps=$figfolder`echo $iSnapshot | cut -d '.' -f 1`.ps
eps=$figfolder`echo $iSnapshot | cut -d '.' -f 1`.eps
pdf=$figfolder`echo $iSnapshot | cut -d '.' -f 1`.pdf

paste -d ' ' $meshGridFile $backupfolder$iSnapshot | awk  -v scale="$scale" -v normalization="$normalization" '{ if($3 >=(-normalization) && $3<=normalization){print $1/scale, $2/scale, $3/normalization} }'> $snapshotFile
cat $snapshotFile | gmt blockmean -R$region -I$inc | gmt surface -Ll$lowerLimit -Lu$upperLimit -R$region -I$inc -G$grd
gmt grdimage -R$region -J$projection  -Bxa1f0.5+l"Horizontal offset (m) " -Bya1f0.5+l"Vertical offset (m)" $grd -C$cpt -K > $ps
awk -v scale="$scale" '{ print $1/scale, $2/scale }' $topo_polygon | gmt psxy -R -J  -Ggray -W1p -O -K >> $ps #-L+yt -Ggray 
awk -v scale="$scale" '{ print $1/scale, $2/scale }' $receiver | gmt psxy -R -J -St0.05i -Gblue -N -Wthinner,black -O -K >> $ps
awk -v scale="$scale" '{ print $1/scale, $2/scale }' $source   | gmt psxy -R -J -Sa0.05i -Gred  -N -Wthinner,black -O    >> $ps

#gmt psscale -D$domain -C$cpt -E -Bx1f0.5 -O | sed "s/$minOldString1/$minNewString1/g" | sed "s/$minOldString2/$minNewString2/g" | sed "s/$maxOldString1/$maxNewString1/g" | sed "s/$maxOldString2/$maxNewString2/g">> $ps

rm -f $grd
gmt ps2raster -A -Te $ps -D$figfolder
epstopdf --outfile=$pdf $eps
rm -f $ps $eps
rm -f $figfolder/ps2raster_*bb

done

rm $figfolder\wavefield00000*_01.pdf
gs -dBATCH -dNOPAUSE -q -sDEVICE=pdfwrite -sOutputFile=$figfolder\merged.pdf $figfolder\wavefield0*_01.pdf
