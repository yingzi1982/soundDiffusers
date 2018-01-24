#!/usr/bin/env gnuplot
set terminal postscript eps size 2.8,1.2 enhanced color font 'Helvetica,12' 
set output '../figures/source.eps'
set key off
#set grid xtics ytics
#set key inside vertical right top title ''
unset key
#set title ""
#set xlabel "Time (s)"
#set ylabel "Normalized amplitude" offset 1,0
#--------------------------------
set multiplot
unset key
unset xlabel
set border 1+2+4
set lmargin at screen 0.13
set rmargin at screen 0.38
set bmargin at screen 0.25
set tmargin at screen 0.95
set ylabel 'Normalized amplitude' offset 1
unset xlabel

set xrange [-10:-2]
set yrange [-1:1.]
set xtics (-5,-10)
set ytics -1,0.5,1 nomirror
unset arrow
tiny_x=0.1
tiny_z=0.1
point_x=-2
point_z=-1
set arrow from point_x-tiny_x, point_z-tiny_z to point_x+tiny_x, point_z+tiny_z nohead
point_x=-2
point_z=+1
set arrow from point_x-tiny_x, point_z-tiny_z to point_x+tiny_x, point_z+tiny_z nohead
point_x=-2
point_z=-0
set arrow from point_x-tiny_x, point_z-tiny_z to point_x+tiny_x, point_z+tiny_z nohead
point_x=-2
point_z=+0
set arrow from point_x-tiny_x, point_z-tiny_z to point_x+tiny_x, point_z+tiny_z nohead
plot '../backup/sourceTimeFunction' using($1):($2) with lines linewidth 2 linecolor 7 title ''
#--------------------------------
set border 1+4
set lmargin at screen 0.41
set rmargin at screen 0.66
set bmargin at screen 0.25
set tmargin at screen 0.95

set xrange [-0.2:0.2]
set yrange [-1:1.]
unset ylabel
set xlabel 'Time (s)'
set xtics (-0.1,0,0.1)
unset ytics
unset arrow
tiny_x=0.1/20
tiny_z=0.1
point_x=-0.2
point_z=-1
set arrow from point_x-tiny_x, point_z-tiny_z to point_x+tiny_x, point_z+tiny_z nohead
point_x=-0.2
point_z=+1
set arrow from point_x-tiny_x, point_z-tiny_z to point_x+tiny_x, point_z+tiny_z nohead
point_x=-0.2
point_z=-0
set arrow from point_x-tiny_x, point_z-tiny_z to point_x+tiny_x, point_z+tiny_z nohead
point_x=-0.2
point_z=+0
set arrow from point_x-tiny_x, point_z-tiny_z to point_x+tiny_x, point_z+tiny_z nohead
point_x=0.2
point_z=-1
set arrow from point_x-tiny_x, point_z-tiny_z to point_x+tiny_x, point_z+tiny_z nohead
point_x=0.2
point_z=+1
set arrow from point_x-tiny_x, point_z-tiny_z to point_x+tiny_x, point_z+tiny_z nohead
point_x=0.2
point_z=-0
set arrow from point_x-tiny_x, point_z-tiny_z to point_x+tiny_x, point_z+tiny_z nohead
point_x=0.2
point_z=+0
set arrow from point_x-tiny_x, point_z-tiny_z to point_x+tiny_x, point_z+tiny_z nohead
plot '../backup/sourceTimeFunction' using($1):($2) with lines linewidth 2 linecolor 7 title ''
#--------------------------------
set border 1+4+8
set lmargin at screen 0.69
set rmargin at screen 0.94
set bmargin at screen 0.25
set tmargin at screen 0.95

set xtics (5,10)
unset ytics
set xrange [2:10]
set yrange [-1:1.]
unset ylabel
unset xlabel
unset arrow
tiny_x=0.1
tiny_z=0.1
point_x=2
point_z=-1
set arrow from point_x-tiny_x, point_z-tiny_z to point_x+tiny_x, point_z+tiny_z nohead
point_x=2
point_z=+1
set arrow from point_x-tiny_x, point_z-tiny_z to point_x+tiny_x, point_z+tiny_z nohead
point_x=2
point_z=-0
set arrow from point_x-tiny_x, point_z-tiny_z to point_x+tiny_x, point_z+tiny_z nohead
point_x=2
point_z=+0
plot '../backup/sourceTimeFunction' using($1):($2) with lines linewidth 2 linecolor 7 title ''
unset multiplot
