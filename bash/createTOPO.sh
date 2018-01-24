#!/bin/bash
srtm=srtm_12_03
cd ../backup
#wget http://srtm.csi.cgiar.org/SRT-ZIP/SRTM_v41/SRTM_Data_ArcASCII/${srtm}.zip
#unzip -f ${srtm}.zip

#../perl/esri-asc2xyz.pl < ${srtm}.asc > ${srtm}.xyz

source /usr/share/modules/init/bash
module load apps gmt/intel/5.1.0 
region=-122.5006/-121.8787/45.9841/46.4159
inc=1s/1s
projection=m-122.1897/46.2

gcTopoFile=${srtm}.xyz
bmTopoFile=TOPO.xyz
ccTopoFile=TOPO.utm
blockmedian ${gcTopoFile} -R${region} -I${inc} > ${bmTopoFile}
mapproject ${bmTopoFile} -R${region} -J${projection} -C -F > ${ccTopoFile}

module unload apps gmt/intel/5.1.0

module load apps octave/intel/3.6.4
cd ../octave
./generateTOPO.m
module unload apps octave/intel/3.6.4

