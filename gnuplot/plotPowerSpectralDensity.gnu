#!/usr/bin/env gnuplot
set terminal postscript eps size 2.8,1.2 enhanced color font 'Helvetica,12' 
dataFile='powerSpectralDensity'
set output '../figures/'.dataFile.'.eps'
set key off
set xtics -2000,1000,2000
set ytics  0,20,100
set mxtics 
set mytics 
set grid xtics ytics
#set key inside vertical right top title ''
unset key
#set title ""
set xrange [-2000:2000]
set yrange [0:100]
set xlabel "Frequency (Hz)"
set ylabel "Power spectral density" offset 1,0
cd '../backup'
stats dataFile using 2 name 'bench'

plot dataFile using($1):($2) with lines linewidth 2 linecolor 7 title ''
