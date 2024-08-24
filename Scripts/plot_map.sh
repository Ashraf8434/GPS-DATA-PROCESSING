#!/bin/bash
dem="dem_dsamp.grd"
gps="GPS.dat"
RR=`gmt grdinfo -I- $dem`
output="demo"
format="jpg"

gmt begin $output $format
    gmt basemap -JM6 $RR -Ba1f0.5
    gmt grdimage $dem -I+nt.3 -Cdem.cpt
    gmt coast -Na/0.5p,black,-.- -Slightblue -Df
    gmt grdsample dE.grd -I0.1 -Gtmpe.grd
    gmt grdsample dN.grd -I0.1 -Gtmpn.grd
    gmt grd2xyz tmpe.grd > tmpe.lld
    gmt grd2xyz tmpn.grd > tmpn.lld
    paste tmpe.lld tmpn.lld | awk '{print $1,$2,$3,$6,"0","0","0"}' > defo.dat
    gmt velo defo.dat -W0.1p,black -Se0.02/0.65/10 -A10p+eA+n10
    gmt plot new_faults.gmt -W0.5p,red
    gmt velo $gps -W1p,blue -Gblack -Se0.02/0.65/12 -A10p+ea+n10 

gmt end show