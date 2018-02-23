#!/usr/bin/env gnuplot
mpl_top    = 0.15 #inch  outer top margin, title goes here
mpl_bot    = 0.69 #inch  outer bottom margin, x label goes here
mpl_left   = 0.35 #inch  outer left margin, y label goes here
mpl_right  = 0.15 #inch  outer right margin, y2 label goes here
mpl_height = 1.2 #inch  height of individual plots
mpl_width  = 1.2 #inch  width of individual plots
mpl_dx     = 0.1 #inch  inter-plot horizontal spacing
mpl_dy     = 0.1 #inch  inter-plot vertical spacing
mpl_ny     = 2   #number of rows
mpl_nx     = 2   #number of columns

colorboxlength=1.2
colorboxheight=0.6


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
set terminal postscript eps size xsize,ysize enhanced color font "Helvetica" 12
set output '../sh/figures/multiImage.eps'

set pm3d map
set palette file '../gnuplot/colormap.gpf'
#set cbtics 
set cblabel 'Normalized amplitude'
unset contour
unset colorbox
unset key
set size square
#set offsets

# define x-axis settings for all subplots
#set xlabel ''
#set ylabel ''
#set format x ''
#set format y ''
#set grid xtics ytics
set mxtics
set mytics
textLabelXPosition=0.15
textLabelYPosition=0.15
numberingLabelXPosition=-0.08
numberingLabelYPosition=1.05
set style line 2 ps 0.6 lc rgb 'brown' pt 9

#-----------------------------------------------
# start plotting
set multiplot
#-----------------------------------------------
dataFile = '../sh/0/backup/image_bv'
nrow=2
ncol=1
set lmargin at screen left(ncol)
set rmargin at screen right(ncol)
set tmargin at screen top(nrow)
set bmargin at screen bot(nrow)
unset label
unset arrow
set cbrange [-1:1] 
set noautoscale cb
set noautoscale z
set ylabel 'Depth (km)'
set xlabel ''
set xrange [-3:3]
set yrange [-8:-2]
set xtics ("" -2, "" 0, "" 2)
set ytics ("-7" -7, "-5" -5, "-3" -3)
set mxtics
set mytics
set label 'a)' at graph numberingLabelXPosition,numberingLabelYPosition left front font 'bold,12' textcolor rgb 'black'
set label '+' font ',12' at 0,-5 center front textcolor rgb 'brown'
dataColumn=3
splot '< sort -g -k1 -k2 '.dataFile.' | uniq | awk -f ../bash/addblanks.awk' using(column(1)/1000):(column(2)/1000):(column(dataColumn)) with pm3d notitle
#-----------------------------------------------
dataFile = '../sh/4/backup/image_bv'
nrow=2
ncol=2
set lmargin at screen left(ncol)
set rmargin at screen right(ncol)
set tmargin at screen top(nrow)
set bmargin at screen bot(nrow)
unset label
unset arrow
set ylabel ''
set xlabel ''
set cbrange [-1:1] writeback
set xrange [-3:3]
set yrange [-8:-2]
set xtics ("" -2, "" 0, "" 2)
set ytics ("" -7, "" -5, "" -3)
dataColumn=3
set label 'b)' at graph numberingLabelXPosition,numberingLabelYPosition left front font 'bold,12' textcolor rgb 'black'
set label '+' font ',12' at 0,-5 center front textcolor rgb 'brown'
splot '< sort -g -k1 -k2 '.dataFile.' | uniq | awk -f ../bash/addblanks.awk' using(column(1)/1000):(column(2)/1000):(column(dataColumn)) with pm3d notitle

#-----------------------------------------------
dataFile = '../sh/8/backup/image_bv'
nrow=1
ncol=1
set lmargin at screen left(ncol)
set rmargin at screen right(ncol)
set tmargin at screen top(nrow)
set bmargin at screen bot(nrow)
unset label
unset arrow
set ylabel 'Depth (km)'
set xlabel 'Range (km)'
#set cbrange [-1:1] 
set xrange [-3:3]
set yrange [-8:-2]
set xtics ("-2" -2, "0" 0, "2" 2)
set ytics ("-7" -7, "-5" -5, "-3" -3)
set label 'c)' at graph numberingLabelXPosition,numberingLabelYPosition left front font 'bold,12' textcolor rgb 'black'
set label '+' font ',12' at 0,-5 center front textcolor rgb 'brown'
dataColumn=3
splot '< sort -g -k1 -k2 '.dataFile.' | uniq | awk -f ../bash/addblanks.awk' using(column(1)/1000):(column(2)/1000):(column(dataColumn)) with pm3d notitle
#-----------------------------------------------
dataFile = '../sh/12/backup/image_bv'
nrow=1
ncol=2
set lmargin at screen left(ncol)
set rmargin at screen right(ncol)
set tmargin at screen top(nrow)
set bmargin at screen bot(nrow)
unset label
unset arrow
set ylabel ''
set xlabel 'Range (km)'
set cbrange [-1:1] 
set xrange [-3:3]
set yrange [-8:-2]
set xtics ("-2" -2, "0" 0, "2" 2)
set ytics ("" -7, "" -5, "" -3)
dataColumn=3
set label 'd)' at graph numberingLabelXPosition,numberingLabelYPosition left front font 'bold,12' textcolor rgb 'black'
set label '+' font ',12' at 0,-5 center front textcolor rgb 'brown'
splot '< sort -g -k1 -k2 '.dataFile.' | uniq | awk -f ../bash/addblanks.awk' using(column(1)/1000):(column(2)/1000):(column(dataColumn)*column(dataColumn)) with pm3d notitle

#-----------------------------------------------
#-----------------------------------------------
colorboxlengthratio=colorboxlength/xsize
colorboxheightratio=colorboxheight/ysize
set lmargin at screen right(1)+mpl_dx/2/xsize-(colorboxlengthratio/2)
set rmargin at screen right(1)+mpl_dx/2/xsize+(colorboxlengthratio/2)
set tmargin at screen 0.0+colorboxheightratio
set bmargin at screen 0.02
g(x)=x
set xrange [0:1]
set tics out; unset ytics;
set size ratio 0.058
set xtics add ("0" 0, "0.5" 0.5, "1" 1) nomirror  offset 0,0.25
set xlabel 'Normalized amplitude' offset 0,0.75
unset label
unset arrow
splot g(x) with pm3d notitle
#-----------------------------------------------
unset multiplot
