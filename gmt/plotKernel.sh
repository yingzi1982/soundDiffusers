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

figfolder=../figures/

cptfile=ViBlGrWhYeOrRe.cpt
#cptfile=BlueWhiteOrangeRed.cpt
#cptfile=GMT_seis.cpt

name=kernel
#-----------------------------------------------------
for type in sh psv
#for type in psv 
do

if [ $type == sh ];
then
col_array=(8)
normalization_array=(1e-5)
elif [ $type == psv ];
then
col_array=(7 8)
normalization_array=(3e-6 6e-6)
fi

for index in ${!col_array[*]}
do

col=${col_array[$index]}
normalization=${normalization_array[$index]}

ps=$figfolder$name\_$type\_$col.ps
eps=$figfolder$name\_$type\_$col.eps
pdf=$figfolder$name\_$type\_$col.pdf

domain=2.7i/-0.075i/1.2i/0.16ih
length=1.8i
projection=X$length
inc=0.2
minOldString1='(-1) sh mx'
minNewString1='(-max) sh mx'
maxOldString1='(1) sh mx'
maxNewString1='(max) sh mx'

minOldString2='(-1) bc Z'
minNewString2='(-max) bc Z'
maxOldString2='(1) bc Z'
maxNewString2='(max) bc Z'

xmin=-30
xmax=30
ymin=-30
ymax=30
zmin=-1
zmax=1
zinc=`echo "($zmax-($zmin))/100" | bc -l`

region=$xmin/$xmax/$ymin/$ymax

#---------------------------------------------
gmt gmtset MAP_FRAME_AXES wesn
backupfolder=../$type/0/backup/
#normalization=`awk -v col="$col" -v backupfolder="$backupfolder" '{ print $(col-2) }' $backupfolder\normalization`
source=$backupfolder\source
receiver=$backupfolder\receiver
originalxyz=$backupfolder$name.xyz
processedxyz=$backupfolder$name.xyz.processed
cpt=$backupfolder$name.cpt
grd=$backupfolder$name.nc
grad=$backupfolder$name.int.nc
lambda=`cat $backupfolder\lambda`

gmt makecpt -C$cptfile -T$zmin/$zmax/$zinc > $cpt

cat $originalxyz | awk -v lambda="$lambda" -v col="$col" -v normalization="$normalization" '{ print $1/lambda, $2/lambda, $col/normalization }' | blockmean -R$region -I$inc > $processedxyz
cat $processedxyz | gmt blockmode -R$region -I$inc | gmt surface -R$region -I$inc -G$grd
gmt grdgradient $grd -A15 -Ne0.75 -G$grad

#gmt grdimage -R$region -J$projection $grd -C$cpt -Bxa20f10+l"Horizontal offset (@~l@~@-s@-)" -Bya20f10+l"Vertical offset (@~l@~@-s@-)" -Y5i -K> $ps #  Bya2fg2
gmt grdimage -R$region -J$projection $grd -C$cpt -Bxa20f10+l"Horizontal offset" -Bya20f10+l"Vertical offset" -Y5i -K> $ps #  Bya2fg2
awk -v lambda="$lambda" '{ print $1/lambda, $2/lambda }' $receiver | gmt psxy -R -J -St0.05i -Gred -N -Wthinner,black -O -K >> $ps
awk -v lambda="$lambda" '{ print $1/lambda, $2/lambda }' $source   | gmt psxy -R -J -Sa0.05i -Gred -N -Wthinner,black -O -K >> $ps
echo "-25 22 (a)" | gmt pstext -R -J -F+jLB -N -O -K >> $ps
rm -f $grd $grad $cpt $processedxyz
#---------------------------------------------
gmt gmtset MAP_FRAME_AXES wesn
backupfolder=../$type/4/backup/
#normalization=`awk -v col="$col" -v backupfolder="$backupfolder" '{ print $(col-2) }' $backupfolder\normalization`
source=$backupfolder\source
receiver=$backupfolder\receiver
originalxyz=$backupfolder$name.xyz
processedxyz=$backupfolder$name.xyz.processed
cpt=$backupfolder$name.cpt
grd=$backupfolder$name.nc
grad=$backupfolder$name.int.nc
lambda=`cat $backupfolder\lambda`

gmt makecpt -C$cptfile -T$zmin/$zmax/$zinc > $cpt

cat $originalxyz | awk -v lambda="$lambda" -v col="$col" -v normalization="$normalization" '{ print $1/lambda, $2/lambda, $col/normalization }' | blockmean -R$region -I$inc > $processedxyz
cat $processedxyz | gmt blockmode -R$region -I$inc | gmt surface -R$region -I$inc -G$grd
gmt grdgradient $grd -A15 -Ne0.75 -G$grad

#gmt grdimage -R$region -J$projection $grd -C$cpt -Bxa20f10+l"Horizontal offset (@~l@~@-s@-)" -Bya20f10+l"Vertical offset (@~l@~@-s@-)" -X$length -O -K >> $ps #  Bya2fg2
gmt grdimage -R$region -J$projection $grd -C$cpt -Bxa20f10+l"Horizontal offset" -Bya20f10+l"Vertical offset" -X$length -O -K >> $ps #  Bya2fg2
awk -v lambda="$lambda" '{ print $1/lambda, $2/lambda }' $receiver | gmt psxy -R -J -St0.05i -Gred -N -Wthinner,black -O -K >> $ps
awk -v lambda="$lambda" '{ print $1/lambda, $2/lambda }' $source   | gmt psxy -R -J -Sa0.05i -Gred -N -Wthinner,black -O -K >> $ps
echo "-25 22 (b)" | gmt pstext -R -J -F+jLB -N -O -K >> $ps
rm -f $grd $grad $cpt $processedxyz
#---------------------------------------------
gmt gmtset MAP_FRAME_AXES wesn
backupfolder=../$type/12/backup/
#normalization=`awk -v col="$col" -v backupfolder="$backupfolder" '{ print $(col-2) }' $backupfolder\normalization`
source=$backupfolder\source
receiver=$backupfolder\receiver
originalxyz=$backupfolder$name.xyz
processedxyz=$backupfolder$name.xyz.processed
cpt=$backupfolder$name.cpt
grd=$backupfolder$name.nc
grad=$backupfolder$name.int.nc
lambda=`cat $backupfolder\lambda`

gmt makecpt -C$cptfile -T$zmin/$zmax/$zinc > $cpt

cat $originalxyz | awk -v lambda="$lambda" -v col="$col" -v normalization="$normalization" '{ print $1/lambda, $2/lambda, $col/normalization }' | blockmean -R$region -I$inc > $processedxyz
cat $processedxyz | gmt blockmode -R$region -I$inc | gmt surface -R$region -I$inc -G$grd
gmt grdgradient $grd -A15 -Ne0.75 -G$grad

#gmt grdimage -R$region -J$projection $grd -C$cpt -Bxa20f10+l"Horizontal offset (@~l@~@-s@-)" -Bya20f10+l"Vertical offset (@~l@~@-s@-)" -Y-$length -O -K >> $ps #  Bya2fg2
gmt grdimage -R$region -J$projection $grd -C$cpt -Bxa20f10+l"Horizontal offset" -Bya20f10+l"Vertical offset" -Y-$length -O -K >> $ps #  Bya2fg2
awk -v lambda="$lambda" '{ print $1/lambda, $2/lambda }' $receiver | gmt psxy -R -J -St0.05i -Gred -N -Wthinner,black -O -K >> $ps
awk -v lambda="$lambda" '{ print $1/lambda, $2/lambda }' $source   | gmt psxy -R -J -Sa0.05i -Gred -N -Wthinner,black -O -K >> $ps
echo "-25 22 (d)" | gmt pstext -R -J -F+jLB -N -O -K >> $ps
rm -f $grd $grad $cpt $processedxyz
#---------------------------------------------
gmt gmtset MAP_FRAME_AXES WeSn
backupfolder=../$type/8/backup/
#normalization=`awk -v col="$col" -v backupfolder="$backupfolder" '{ print $(col-2) }' $backupfolder\normalization`
source=$backupfolder\source
receiver=$backupfolder\receiver
originalxyz=$backupfolder$name.xyz
processedxyz=$backupfolder$name.xyz.processed
cpt=$backupfolder$name.cpt
grd=$backupfolder$name.nc
grad=$backupfolder$name.int.nc
lambda=`cat $backupfolder\lambda`

gmt makecpt -C$cptfile -T$zmin/$zmax/$zinc > $cpt

cat $originalxyz | awk -v lambda="$lambda" -v col="$col" -v normalization="$normalization" '{ print $1/lambda, $2/lambda, $col/normalization }' | blockmean -R$region -I$inc > $processedxyz
cat $processedxyz | gmt blockmode -R$region -I$inc | gmt surface -R$region -I$inc -G$grd
gmt grdgradient $grd -A15 -Ne0.75 -G$grad

#gmt grdimage -R$region -J$projection $grd -C$cpt -Bxa20f10+l"Horizontal offset (@~l@~@-s@-)" -Bya20f10+l"Vertical offset (@~l@~@-s@-)" -X-$length -O -K >> $ps #  Bya2fg2
gmt grdimage -R$region -J$projection $grd -C$cpt -Bxa20f10+l"Horizontal offset" -Bya20f10+l"Vertical offset" -X-$length -O -K >> $ps #  Bya2fg2
awk -v lambda="$lambda" '{ print $1/lambda, $2/lambda }' $receiver | gmt psxy -R -J -St0.05i -Gred -N -Wthinner,black -O -K >> $ps
awk -v lambda="$lambda" '{ print $1/lambda, $2/lambda }' $source   | gmt psxy -R -J -Sa0.05i -Gred -N -Wthinner,black -O -K >> $ps
echo "-25 22 (c)" | gmt pstext -R -J -F+jLB -N -O -K >> $ps
#---------------------------------------------
gmt psscale -D$domain -C$cpt -E -Bx1f0.5 -O | sed "s/$minOldString1/$minNewString1/g" | sed "s/$minOldString2/$minNewString2/g" | sed "s/$maxOldString1/$maxNewString1/g" | sed "s/$maxOldString2/$maxNewString2/g">> $ps
rm -f $grd $grad $cpt $processedxyz

gmt ps2raster -A -Te $figfolder$ps -D$figfolder
epstopdf --outfile=$pdf $eps
rm -f $figfolder\ps2raster_*bb
rm -f $ps

done
done

