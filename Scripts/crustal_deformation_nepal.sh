#!/bin/bash

# Define input and output files
input_file="glredts.vel"
output_file="Gorkha_2015_Crustal_Deformation"

# Define the region of interest (longitude and latitude bounds)
region="80/90/26/31"
# Define the projection (Mercator projection in this example)
projection="M8i"
cpt="crustal_def.cpt"

# Create the color palette
gmt makecpt -Cworld -T0/9000/100 > $cpt

# Topography data
TOPO_DATA="@earth_relief_01m"

# GPS data file (format: lon lat Evel Nvel dEvel dNvel E+- N+- Rne Hvel dHvel H+- Site)
GPS_DATA="gps_data_extracted.txt"

# Extract relevant columns from glredts.vel and add dummy values for missing columns
awk 'NR>11 {print $1, $2, $3, $4, "0", "0", $5, $6, "0", "0", "0", "0", $13}' $input_file > $GPS_DATA

# Start GMT session
gmt begin $output_file jpg
  gmt basemap -R$region -J$projection -Baf -BWSne+t"Gorkha Earthquake 2015 Crustal Deformation"
  gmt grdimage $TOPO_DATA -R$region -J$projection -C$cpt -I+d
  gmt velo $GPS_DATA -R$region -J$projection -Se0.1/0.95/0.5 -W0.5p,black
  # Add colorbar
  gmt colorbar -Dx8c/1c+w12c/0.5c+jTC+h -Bxaf+l"topography" -By+lkm
gmt end show
