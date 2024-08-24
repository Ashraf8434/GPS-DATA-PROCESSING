#!/bin/bash

# Input file
input_file="besi.csv"
# Define the region and projection
projection=X15c/14c

# Extract the minimum and maximum values for the x-axis (time)
x_min=$(awk -F, 'NR>1 {print $1}' $input_file | sort -n | head -1)
x_max=$(awk -F, 'NR>1 {print $1}' $input_file | sort -n | tail -1)

echo "x min is: $x_min"
echo "x max is: $x_max"

# Extract the minimum and maximum values for the North component
north_min=$(awk -F, 'NR>1 {print $2}' $input_file | sort -n | head -1)
north_max=$(awk -F, 'NR>1 {print $2}' $input_file | sort -n | tail -1)
echo "North min is: $north_min"
echo "North max is: $north_max"

# Extract the minimum and maximum values for the East component
east_min=$(awk -F, 'NR>1 {print $3}' $input_file | sort -n | head -1)
east_max=$(awk -F, 'NR>1 {print $3}' $input_file | sort -n | tail -1)
echo "East min is: $east_min"
echo "East max is: $east_max"

# Extract the minimum and maximum values for the Vertical component
vertical_min=$(awk -F, 'NR>1 {print $4}' $input_file | sort -n | head -1)
vertical_max=$(awk -F, 'NR>1 {print $4}' $input_file | sort -n | tail -1)
echo "Vertical min is: $vertical_min"
echo "Vertical max is: $vertical_max"

# Define the region for each component plot
region_north=$x_min/$x_max/$north_min/$north_max
region_east=$x_min/$x_max/$east_min/$east_max
region_vertical=$x_min/$x_max/$vertical_min/$vertical_max

# Filter data up to 2015 and store in temporary files
awk -F, 'NR>1 || ($1 < 2016)' $input_file > data_up_to_2015.csv
awk -F, 'NR>1 || ($1 >= 2016)' $input_file > data_from_2016.csv

# Calculate the best-fit lines using gmtregress for each set of data
gmt gmtregress data_up_to_2015.csv -i0,1,2 -Fxm  > fit_up_to_2015_north.txt
gmt gmtregress data_from_2016.csv -i0,1, > fit_from_2016_north.txt

gmt gmtregress data_up_to_2015.csv -i0,2,5 > fit_up_to_2015_east.txt
gmt gmtregress data_from_2016.csv -i0,2,5 > fit_from_2016_east.txt

gmt gmtregress data_up_to_2015.csv -i0,3,6 > fit_up_to_2015_vertical.txt
gmt gmtregress data_from_2016.csv -i0,3 > fit_from_2016_vertical.txt

# Plotting all components in a single PDF page with separate panels
gmt begin BESI_PLOTS
  # North component plot
  gmt subplot begin 3x1 -Fs5c/10c -M2.5c
    gmt basemap -R$region_north -J$projection -Bxaf1+l"Time (Year)" -Bya0.01f1+l"North (m)" -B+t"BESI Station: North Component"
    gmt plot $input_file -i0,1,4 -Sc0.2c -Gblue -Wthinner -Ey+p0.1p,grey
    gmt plot fit_up_to_2015_north.txt -W2p,red
    #gmt plot fit_from_2016_north.txt -W2p,green
  gmt subplot end
 
  gmt subplot end
gmt end show

# Clean up temporary files