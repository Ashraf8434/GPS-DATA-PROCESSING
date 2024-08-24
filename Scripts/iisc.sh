#!/bin/bash

#input_file="iisc_gps_data_extracted.txt"
input_file="time_series_data.csv"

#cat $input_file

#minimum and maximum values for the x-axis
x_min=$(gmt info -C $input_file | cut -f1)
x_max=$(gmt info -C $input_file | cut -f2)

echo $x_min
echo $x_max

#minimum and maximum values for the y-axis
y_min=$(gmt info -C $input_file | cut -f3)
y_max=$(gmt info -C $input_file | cut -f4)

echo $y_min
echo $y_max
# Set the time format for the x-axis
gmt set TIME_FORMAT_PRIMARY yyyy
gmt set FORMAT_DATE_MAP yyyy

# Create the plot for the North component
gmt begin north_component_plot png
  gmt plot $input_file -i0,1 -Sc0.01c -W1p,blue -Bxafg+l"Time (Year)" -Byafg+l"North (m)" -B+t"GPS Time Series: North Component" -JX15c/10c -R$x_min/$x_max/$y_min/$y_max
  #Plot of the Standard Deviation of the North Component
  gmt plot $input_file -c0,5 -Sc0.1c -G128  # Medium gray

gmt end show

# Create the plot for the East component
gmt begin east_component_plot png
  gmt plot $input_file -i0,2 -S+0.03c -W1p,red -Bxafg+l"Time (year)" -Byafg+l"East (m)" -B+t"GPS Time Series: East Component" -JX15c/10c -R$x_min/$x_max/$y_min/$y_max
 # Consider the east component error
gmt end show

#Create the plot for the Vertical component

gmt begin vertical_component_plot png
  gmt plot $input_file -i0,3 -Sc0.03c -Gblack -Bxafg+l"Time (year)" -Byafg+l"Vertical (m)" -B+t"Vertical Component" -JX15c/10c -R$x_min/$x_max/$y_min/$y_max

  #Consider the vertical component error
  #gmt plot $input_file -Sc0.1c -G128  # Medium gray
gmt end show

# Calculation of the velocity wrt time of the north component and east component

# Prepare the x-values file
cat << EOF > x_values.txt
2005
2010
2015
2020
EOF

# Perform interpolation
gmt sample1d $input_file -T2005/2020/5 -Fa > interpolated_values.txt

# View the result
#cat interpolated_values.txt

# View the result as a table
echo -e "Year\tNorth Component (m)\tEast Component (m)\tVelocity (m/year)"
#awk '{print $1 "\t" $2 "\t" $3 "\t" $4}' interpolated_values.txt

#Now calculation of the long-term rate of the north component

# Extract interpolated values for the years 2005 and 2015
north_2005=$(awk '$1 == 2005 {print $2}' interpolated_values.txt)
north_2015=$(awk '$1 == 2015 {print $2}' interpolated_values.txt)

# Calculate the long-term rate for the North component
long_term_rate_north=$(echo "scale=10; ($north_2015 - $north_2005) / (2015 - 2005)" | bc)
echo "Long-term rate for the North component: $long_term_rate_north m/year"

#in mm
echo "Long-term rate for the North component: $(echo "$long_term_rate_north*1000" | bc) mm/year"


#Now Calculation of the long_term_rate of the east component
east_2005=$(awk '$1 == 2005 {print $3}' interpolated_values.txt)
east_2015=$(awk '$1 == 2015 {print $3}' interpolated_values.txt)


long_term_rate_east=$(echo "scale=10; ($east_2015 - $east_2005) / (2015 - 2005)" | bc)

echo "Long-term rate for the East component: $long_term_rate_east m/year"

echo "Long-term rate for the East component: $(echo "$long_term_rate_east*1000" | bc) mm/year"


# Now we have to calculate the total rate 

total_rate=$(echo "sqrt(($long_term_rate_east)^2 + ($long_term_rate_north)^2)" | bc -l)
echo "Total rate of the IISc station is (in mm): $total_rate m/yr"

#in mm
echo "Total rate of the IISc station is: $(echo "$total_rate*1000" | bc) mm/year"









