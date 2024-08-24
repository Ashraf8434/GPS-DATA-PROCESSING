#!/bin/bash

#Plot vector  of the gps data
echo 0 0 1 1 0.2 0.2 0.5 > tmp.dat
JRB="-JX3/3 -R-1/2/-1/2 -Ba1f1g1"
gmt begin vec png
 gmt velo tmp.dat $JRB -Se1.0/0.65/10 -W1p -A10p+ea+bi+gblue+a90





gmt end show
