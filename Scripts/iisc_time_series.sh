#!/bin/bash

# Input file
input_file="time_series_data.csv"

# Minimum and maximum values for the x-axis
x_min=$(awk -F, '{if(NR>1)print $1}' $input_file | sort -n | head -1)
x_max=$(awk -F, '{if(NR>1)print $1}' $input_file | sort -n | tail -1)

echo "x min is: $x_min"
echo "x max is: $x_max"

#mininimum and maximum values for the north component
# Find minimum and maximum values of column 2
north_min=$(awk -F, '{if(NR>1)print $2}' $input_file | sort -n | head -1)
north_max=$(awk -F, '{if(NR>1)print $2}' $input_file | sort -n | tail -1)
#Min and max values of the east component
east_min=$(awk -F, '{if(NR>1)print $3}' $input_file | sort -n | head -1)
east_max=$(awk -F, '{if(NR>1)print $3}' $input_file | sort -n | tail -1)
echo "North min is: $north_min"
echo "North max is: $north_max"
echo "East min is: $east_min"
echo "East max is: $east_max"

# Find minimum and maximum values of column 4(Vertical component)
vertical_min=$(awk -F, '{if(NR>1)print $4}' $input_file | sort -n | head -1)
vertical_max=$(awk -F, '{if(NR>1)print $4}' $input_file | sort -n | tail -1)

echo "Verical min is: $vertical_min"
echo "vertical max is: $vertical_max"

# Find minimum and maximum values of column SDN
SDN_min=$(awk -F, '{if(NR>1)print $5}' $input_file | sort -n | head -1)
SDN_max=$(awk -F, '{if(NR>1)print $5}' $input_file | sort -n | tail -1)

echo "SDN min is: $SDN_min"
echo "SDN max is: $SDN_max"

# Find minimum and maximum values of column SDE
SDE_min=$(awk -F, '{if(NR>1)print $6}' $input_file | sort -n | head -1)
SDE_max=$(awk -F, '{if(NR>1)print $6}' $input_file | sort -n | tail -1)

echo "SDE min is: $SDE_min"
echo "SDE max is: $SDE_max"

# Find minimum and maximum values of column SDV
SDV_min=$(awk -F, '{if(NR>1)print $7}' $input_file | sort -n | head -1)
SDV_max=$(awk -F, '{if(NR>1)print $7}' $input_file | sort -n | tail -1)
echo "SDV min is: $SDV_min"
echo "SDV max is: $SDV_max"
# Define the region and projection
projection=X33c/10c
region_vertical=$x_min/$x_max/-0.03/0.03
# Plot the Vertical component
gmt begin vertical_iisc_err
  gmt basemap -R$region_vertical -J$projection -Bxa5f1+l"Time (Year)" -Bya0.01f1+l"Vertical(m)" -B+t"IISC Station: Vertical Component"
  #Plotting of the main data set of the IIsc station of the vertical component
  #Error plot 
  gmt plot $input_file -i0,3,6 -Sc0.2c -Ey+p0.2p,grey #-Gblack -Wthinner -l"Error in vertical data"
  #Main plot of the Vertical component
  gmt plot $input_file -i0,3 -Sc0.2c -Gblue -Wthinner #-l"Vertical data"
  #gmt legend -DjBR+o0.2c/0c+w5c/2c -F+gwhite+p1p
gmt end show
# Plot the North component
region_north=$x_min/$x_max/-0.4/0.4
gmt begin north_comp 
  gmt basemap -R$region_north -J$projection -Bxa5f1+l"Time (Year)" -Bya0.2+l"North(m)" -B+t"IISc Station: North Component"
  gmt plot $input_file -i0,1,4 -Sc0.2c -Gmagenta -Wthinner -Ey+p0.1p,grey 
gmt end show
# plot the east component
region_east=$x_min/$x_max/-0.4/0.4
gmt begin east_comp_plot png
    gmt basemap -R$region_east -J$projection -Bxa5f1+l"Time (year)" -Bya0.2+l"East (m)" -B+t"IISc Station: East Component"
    gmt plot $input_file -i0,2,5 -Sc0.2c -Gblue -Wthinner -Ey+p0.1p,wheat
gmt end show


