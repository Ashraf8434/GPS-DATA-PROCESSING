#!/bin/bash

# Define variables
out=nepal_topo_map.ps  # Output PostScript file name
seis_data=anss_eq_2000_2012.dat  # ANSS earthquake catalog (assuming you won't use it)
topo=nepal_topo.nc  # Topography grid file for Nepal (change this to your actual grid file)

# Define map characteristics
north=31.5
south=26
east=89.5
west=80

# Define map boundary annotation
tick='-B2/2WSen'

# Define Map Projection
proj='-JM15'

# Start with GMT commands
# Initialize the basemap
psbasemap -R$west/$east/$south/$north $proj $tick -P -Y12 -K > $out

# Make a color palette for topography
makecpt -Crelief -T-8000/8000/500 -Z > topo.cpt

# Overlay the topography grid
grdimage $topo -R -J -O -K -Ctopo.cpt >> $out

# Add coastlines
pscoast -R -J -O -K -W2 -Df -Na -Ia -Lf80/27/10/200+lkm >> $out

# Add seismic locations (if needed)
# For simplicity, let's skip this unless you have specific seismic data for Nepal
# You can add this part similar to how it was done in the original script

# Add a scale
psscale -D0/3.2/6/1 -B10:Depth:/:km: -Ctopo.cpt -O -K >> $out

# End the plot
gmt psxy -R -J -O -T >> $out

# Convert PostScript to PDF (optional)
# Uncomment the line below if you want to convert the output to PDF
# ps2pdf $out

# Open the output file
open $out
