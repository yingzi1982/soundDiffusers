#!/usr/bin/env gnuplot
mpl_top    = 0.2 #inch  outer top margin, title goes here
mpl_bot    = 0.3 #inch  outer bottom margin, x label goes here
mpl_left   = 0.4 #inch  outer left margin, y label goes here
mpl_right  = 0.1 #inch  outer right margin, y2 label goes here
mpl_height = 2.6 #inch  height of individual plots
mpl_width  = 3.05 #inch  width of individual plots
mpl_dx     = 0.05 #inch  inter-plot horizontal spacing
mpl_dy     = 0.0 #inch  inter-plot vertical spacing
mpl_ny     = 1   #number of rows
mpl_nx     = 2   #number ofcolumns

# calculate full dimensions
xsize = mpl_left+mpl_right+(mpl_width*mpl_nx)+(mpl_nx-1)*mpl_dx
ysize = mpl_top+mpl_bot+(mpl_ny*mpl_height)+(mpl_ny-1)*mpl_dy
print xsize

# placement functions rows are numbered from bottom to top columns are numbered from left to right
bot(n) = (mpl_bot+(n-1)*mpl_height+(n-1)*mpl_dy)/ysize
top(n)  = 1-((mpl_top+(mpl_ny-n)*(mpl_height+mpl_dy))/ysize)
left(n) = (mpl_left+(n-1)*mpl_width+(n-1)*mpl_dx)/xsize
right(n)  = 1-((mpl_right+(mpl_nx-n)*(mpl_width+mpl_dx))/xsize)
#-----------------------------------------------
numberingLabelXPosition=-0.02
numberingLabelYPosition=1.04

#-----------------------------------------------
set terminal postscript eps size xsize,ysize enhanced color font "Helvetica" 12
set output '../psv/figures/multisignal.eps'

set offsets
set autoscale fix

# define x-axis settings for all subplots
#set grid xtics ytics
#set ytics add ("0" 0, "0.5" 0.5, "-0.5" -0.5, " " 1, " " -1)
stationStartNumber = 1
stationEndNumber = 21
set mxtics
set mytics
set ytics 
set xtics ('-1.5' stationStartNumber,'0' (stationStartNumber+stationEndNumber)/2,'1.5' stationEndNumber)
#set xtics add ("200" 2, "250" 3, "300" 4, "350" 5, "400" 6, "450" 7, "500" 8, "550" 9, "600" 10)

labelXPosition=0.05
labelYPosition=0.8
set xrange [stationStartNumber:stationEndNumber]
set yrange [] reverse nowriteback
unset key

verticalDisplacement=0.5

set xrange [stationStartNumber-1:stationEndNumber+1]

#-----------------------------------------------
# start plotting
set multiplot
#-----------------------------------------------

scale=1
# subplot  1-2
set lmargin at screen left(2)
set rmargin at screen right(2)
set tmargin at screen top(1)
set bmargin at screen bot(1)
unset label
unset arrow
set arrow 1 from 8, -0.3 to 11, -0.3 nohead linewidth 2 linecolor 7 linetype 1
set label 2 "8%" at 12, -0.3 right
set arrow 2 from 2, -0.3 to 5, -0.3 nohead linewidth 2 linecolor 1 linetype 4
set label 3 "0%" at 6, -0.3 right

set label 1 'b)' at graph numberingLabelXPosition,numberingLabelYPosition left front font 'bold,12' textcolor rgb 'black'
set ytics ("" 0, "" 2, "" 4, "" 6, "" 8, "" 10)
set xlabel 'Range (km)'
unset ylabel
stats '../psv/0/backup/combinedTrace_Z_1' using (column(1)) name 'tBench'

plot for [n=stationStartNumber:stationEndNumber] '../psv/8/backup/combinedTrace_Z_1' using(column(n+1)*scale+n):(column(1)-tBench_max/2) every 20::30000::50000 with filledcurves above x1=n linewidth 2 linecolor 7 linetype 1 title '',\
     for [n=stationStartNumber:stationEndNumber] '../psv/0/backup/combinedTrace_Z_1' using(column(n+1)*scale+n):(column(1)-tBench_max/2) every 20::30000::50000 with filledcurves above x1=n linewidth 2 linecolor 1 linetype 4 title ''

#-----------------------------------------------
# subplot  1-1
set lmargin at screen left(1)
set rmargin at screen right(1)
set tmargin at screen top(1)
set bmargin at screen bot(1)
unset label
unset arrow
set arrow 1 from 8, -0.3 to 11, -0.3 nohead linewidth 2 linecolor 7 linetype 1
set label 2 "8%" at 12, -0.3 right
set arrow 2 from 2, -0.3 to 5, -0.3 nohead linewidth 2 linecolor 1 linetype 4
set label 3 "0%" at 6, -0.3 right
set label 1 'a)' at graph numberingLabelXPosition,numberingLabelYPosition left front font 'bold,12' textcolor rgb 'black'
set ytics ("0" 0, "2" 2, "4" 4, "6" 6, "8" 8, "10" 10)
set xlabel 'Range (km)'
set ylabel 'Time (s)' 

plot for [n=stationStartNumber:stationEndNumber] '../psv/8/backup/combinedTrace_X_1' using(column(n+1)*scale+n):(column(1)-tBench_max/2) every 20::30000::50000 with filledcurves above x1=n linewidth 2 linecolor 7 linetype 1 title '',\
     for [n=stationStartNumber:stationEndNumber] '../psv/0/backup/combinedTrace_X_1' using(column(n+1)*scale+n):(column(1)-tBench_max/2) every 20::30000::50000 with filledcurves above x1=n linewidth 2 linecolor 1 linetype 4 title ''
#-----------------------------------------------
unset multiplot
