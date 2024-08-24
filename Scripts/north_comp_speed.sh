#!/bin/bash

# Input file
input_file="time_series_data.csv"

# Minimum and maximum values for the x-axis
x_min=$(awk -F, '{if(NR>1)print $1}' $input_file | sort -n | head -1)
x_max=$(awk -F, '{if(NR>1)print $1}' $input_file | sort -n | tail -1)

echo "x min is: $x_min"
echo "x max is: $x_max"

# Minimum and maximum values for the north component
north_min=$(awk -F, '{if(NR>1)print $2}' $input_file | sort -n | head -1)
north_max=$(awk -F, '{if(NR>1)print $2}' $input_file | sort -n | tail -1)
echo "North min is: $north_min"
echo "North max is: $north_max"

# Extract time and north component data
awk -F, 'NR>1 {print $1, $2}' $input_file > time_north_data.txt

#!/bin/bash

# Input file
input_file="time_series_data.csv"

# Skip the header and calculate deformation speed
#!/bin/bash

# Input file
input_file="time_series_data.csv"

# Calculate and print deformation speed (north component)
awk -F',' 'NR > 1 {
    if (prev_time != 0) {
        delta_t = $1 - prev_time;
        delta_n = $2 - prev_north;
        if (delta_t != 0) {
            speed = delta_n / delta_t;
            printf "Time: %f, Deformation Speed (North) in m: %f\n", $1, speed;
        }
    }
    prev_time = $1;
    prev_north = $2;
}' $input_file > north_comp_long_term_rate.txt

#Calculate the average deformation in m
avg_speed_m=$(awk '{ sum += $2; n++ } END { if (n > 0) print sum / n }' north_deformation_speed.txt)
echo "Average Deformation Speed (North) in m:" $avg_speed_m
# Calculate average deformation speed (in mm)
avg_speed_mm=$(awk '{ sum += $2 * 1000; n++ } END { if (n > 0) print sum / n }' north_deformation_speed.txt)
echo "Average Deformation Speed (North) in mm:" $avg_speed_mm

#Plot of the deformation speed
#Define the region and projection for the north component
projection=X33c/10c
region_north=$x_min/$x_max/-0.4/0.4
gmt begin
  gmt plot north_comp_long_term_rate.txt -i1,2 -Sc0.2c -Ggreen -Wthicker
gmt end show













# Define the region and projection for the north component
projection=X33c/10c
region_north=$x_min/$x_max/-0.4/0.4

# Plot the North component and best fit line
gmt begin north_comp
  gmt basemap -R$region_north -J$projection -Bxa5f1+l"Time (Year)" -Bya0.2+l"North (m)" -B+t"IISc Station: North Component"
  gmt plot $input_file -i0,1,4 -Sc0.2c -Gblue -Wthinner -Ey+p0.1p,grey
  gmt plot best_fit_line.txt -Wthinner,red
gmt end show
