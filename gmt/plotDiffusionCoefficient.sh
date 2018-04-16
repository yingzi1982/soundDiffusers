#!/bin/bash
source /usr/share/modules/init/bash
module load apps gmt

#-------
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
#gmtset MAP_ANNOT_ORTHO snew
#gmt gmtset FONT 9p,Times-Roman,black
#gmt gmtset PS_MEDIA custom_2.8ix2.8i
gmt gmtset PS_MEDIA letter   
gmt gmtset PS_PAGE_ORIENTATION portrait
#gmt gmtset GMT_VERBOSE d

figfolder=../figures
mkdir -p $figfolder

for sourceIncidentAngle in 0 30; do
for name in diffusion_coefficient diffusion_coefficient_normalized; do 
ps=$figfolder/$name\_$sourceIncidentAngle.ps
eps=$figfolder/$name\_$sourceIncidentAngle.eps
pdf=$figfolder/$name\_$sourceIncidentAngle.pdf

xmin=100
xmax=20000
ymin=-0.2
ymax=0.8

region=$xmin/$xmax/$ymin/$ymax
projection=X2.8il/1.8i

gmt psbasemap -J$projection -R$region -Bxa1f2g3+l"Frequency (Hz)" -Bya0.2f0.1g0.1+l"Coefficient" -K > $ps
#-------------------------------------
if [[ $name != diffusion_coefficient_normalized ]]; then
topoType=flat
originalxy=../running/$topoType\_$sourceIncidentAngle/backup/$name
color=#808080
awk '{print $1, $2}' $originalxy | gmt psxy -J -R -W1p,$color -N -O -K >> $ps
#awk '{print $1, $2}' $originalxy | gmt psxy -J -R -S- -N -G$color -W -O -K >> $ps
fi
#-------------------------------------
topoType=sine
originalxy=../running/$topoType\_$sourceIncidentAngle/backup/$name
color=#FF0000
awk '{print $1, $2}' $originalxy | gmt psxy -J -R -Wthick,$color,-- -N -O -K >> $ps
awk '{print $1, $2}' $originalxy | gmt psxy -J -R -Sa0.1i -N -G$color -W -O -K >> $ps
#-------------------------------------
topoType=triangle
originalxy=../running/$topoType\_$sourceIncidentAngle/backup/$name
color=#FF7F00
awk '{print $1, $2}' $originalxy | gmt psxy -J -R -Wthick,$color,-- -N -O -K >> $ps
awk '{print $1, $2}' $originalxy | gmt psxy -J -R -Sc0.1i -N -G$color -W -O -K >> $ps
#-------------------------------------
topoType=rectangle
originalxy=../running/$topoType\_$sourceIncidentAngle/backup/$name
color=#FFFF00
awk '{print $1, $2}' $originalxy | gmt psxy -J -R -Wthick,$color,-- -N -O -K >> $ps
awk '{print $1, $2}' $originalxy | gmt psxy -J -R -Sd0.1i -N -G$color -W -O -K >> $ps
#-------------------------------------
topoType=skyline
originalxy=../running/$topoType\_$sourceIncidentAngle/backup/$name
color=#00FF00 
awk '{print $1, $2}' $originalxy | gmt psxy -J -R -Wthick,$color,-- -N -O -K >> $ps
awk '{print $1, $2}' $originalxy | gmt psxy -J -R -Sh0.1i -N -G$color -W -O -K >> $ps
#-------------------------------------
#topoType=gaussian
#originalxy=../running/$topoType\_$sourceIncidentAngle/backup/$name
#color=#0000FF 
#awk '{print $1, $2}' $originalxy | gmt psxy -J -R -Wthick,$color,-- -N -O -K >> $ps
#awk '{print $1, $2}' $originalxy | gmt psxy -J -R -St0.1i -N -G$color -W -O -K >> $ps
#-------------------------------------
#topoType=exponential
#originalxy=../running/$topoType\_$sourceIncidentAngle/backup/$name
#color=#4B0082 
#awk '{print $1, $2}' $originalxy | gmt psxy -J -R -Wthick,$color,-- -N -O -K >> $ps
#awk '{print $1, $2}' $originalxy | gmt psxy -J -R -Sn0.1i -N -G$color -W -O -K >> $ps
#-------------------------------------
topoType=vonkarman
originalxy=../running/$topoType\_$sourceIncidentAngle/backup/$name
color=#9400D3 
awk '{print $1, $2}' $originalxy | gmt psxy -J -R -Wthick,$color,-- -N -O -K >> $ps
awk '{print $1, $2}' $originalxy | gmt psxy -J -R -Ss0.1i -N -G$color -W -O -K >> $ps

region=0/1/0/1
projection=X0.5i/1.8i
gmt psbasemap -J$projection -R$region -B1 -X2.8i --MAP_FRAME_AXES='' -O -K >> $ps

gmt pslegend -Dx0.2/0/0.5i/BL -J -R -O << END >> $ps
S 0i - 0.1i #808080 1p 0.1i flat
S 0i a 0.1i #FF0000 0.25p 0.1i sine
S 0i c 0.1i #FF7F00 0.25p 0.1i triangle
S 0i d 0.1i #FFFF00 0.25p 0.1i rectangle
S 0i h 0.1i #00FF00 0.25p 0.1i skyline
#S 0i t 0.1i #0000FF 0.25p 0.1i gaussian
#S 0i n 0.1i #4B0082 0.25p 0.1i exponential
S 0i s 0.1i #9400D3 0.25p 0.1i vonKarman
END


gmt ps2raster -A -Te $ps -D$figfolder
epstopdf --outfile=$pdf $eps
rm -f $ps $eps
rm -f $figfolder/ps2raster_*bb
done
done
