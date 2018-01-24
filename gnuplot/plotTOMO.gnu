#!/usr/bin/env gnuplot
#dataFile = 'TOMO'
#dataFile = '../backup/TOMO'
dataFile = '../timereversal/sh/8/backup/TOMO'
colNum = 5
stats dataFile using (column(colNum)) name 'bench'

set terminal postscript eps size 2.8,2.2 enhanced color font 'Helvetica,12'
#set terminal postscript eps size 2.8,2.2 enhanced color font 'Helvetica,12'
set output '../figures/TOMO_'.colNum.'.eps'
set lmargin at screen 0.12
set rmargin at screen 0.8
set tmargin at screen 0.96
set bmargin at screen 0.13

#set palette file '../gnuplot/visad.gpf'
#set palette file '../gnuplot/colormap_nonlinear.gpf'
#set palette rgbformulae 33,13,10
# matlab color
set palette defined ( 0 "#000090",\
                      1 "#000fff",\
                      2 "#0090ff",\
                      3 "#0fffee",\
                      4 "#90ff70",\
                      5 "#ffee00",\
                      6 "#ff7000",\
                      7 "#ee0000",\
                      8 "#7f0000")
#set palette gray
set format cb  "%3.1f"

set pm3d map
set cbtics
set cblabel 'S-wave velocity (km/s)' 1,0
set cbrange [2:4]
set cbtics 2,0.5,4
unset contour

unset key
set size square
set colorbox

set xrange [-10:10]
set xtics -10,5,10
set yrange [-10:10]
set ytics -10,5,10
set mxtics 
set mytics 
set xlabel "Range (km)"
set ylabel "Depth (km)"

#set style line 1 lt -1 lw 0.5
set style line 2 ps 0.6 lc rgb 'brown' pt 9
set style arrow 1 nohead linestyle 2 linecolor 7
set arrow from -3,-8,bench_mean to 3,-8,bench_mean as 1 front
set arrow from 3,-8,bench_mean to 3,-2,bench_mean as 1 front
set arrow from 3,-2,bench_mean to -3,-2,bench_mean as 1 front
set arrow from -3,-2,bench_mean to -3,-8,bench_mean as 1 front

set label '{/ZapfDingbats \110}' font ',12' at 0,-5 center front textcolor rgb 'brown'

splot '< sort -g -k1 -k2 '.dataFile.' | uniq | awk -f ../bash/addblanks.awk' using(column(1)/1000):(column(2)/1000):(column(colNum)/1000) with pm3d notitle,\
      '../timereversal/sh/8/backup/STATIONS' using(column(3)/1000):(column(4)/1000):(bench_mean) with points ls 2 notitle
