#!/bin/bash

#Image plot of the antarctica
gmt begin antarctica-image jpg

 gmt basemap -RAQ -JS0/-90/15c -Baf 
 gmt grdimage @earth_relief_10m -I+d -Cgeo
 gmt colorbar -DjBR+o1c/0c+w5c/0.5c -B+l"Elevation (m)"

gmt end show
