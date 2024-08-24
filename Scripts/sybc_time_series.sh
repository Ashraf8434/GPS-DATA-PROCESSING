
input_file="sybc.csv"
# Define the region and projection
projection=X18c/23c

# Extract the minimum and maximum values for the x-axis (time)
x_min=$(awk -F, 'NR>1 {print $1}' $input_file | sort -n | head -1)
x_max=$(awk -F, 'NR>1 {print $1}' $input_file | sort -n | tail -1)

echo "x min is: $x_min"
echo "x max is: $x_max"

# Extract the minimum and maximum values for the North component
north_min=$(awk -F, 'NR>1 {print $2 *100}' $input_file | sort -n | head -1)
north_max=$(awk -F, 'NR>1 {print $2 *100}' $input_file | sort -n | tail -1)
echo "North min is: $north_min"
echo "North max is: $north_max"

# Extract the minimum and maximum values for the East component
east_min=$(awk -F, 'NR>1 {print $3 *100}' $input_file | sort -n | head -1)
east_max=$(awk -F, 'NR>1 {print $3 *100}' $input_file | sort -n | tail -1)
echo "East min is: $east_min"
echo "East max is: $east_max"

# Extract the minimum and maximum values for the Vertical component
vertical_min=$(awk -F, 'NR>1 {print $4 *100}' $input_file | sort -n | head -1)
vertical_max=$(awk -F, 'NR>1 {print $4 *100}' $input_file | sort -n | tail -1)
echo "Vertical min is: $vertical_min"
echo "Vertical max is: $vertical_max"

# Define the region for each component plot
region_north=$x_min/$x_max/$north_min/$north_max
region_east=$x_min/$x_max/$east_min/$east_max
region_vertical=$x_min/$x_max/$vertical_min/$vertical_max

#Filter data up to 2015 and store in temporary files
#awk -F, 'NR>1 || ($1 < 2016)' $input_file > sybc_data_for_bestfit.csv

earthquake_date=2015.39


# Calculate the best-fit lines using gmtregress for each set of data
gmt gmtregress sybc_data_for_bestfit.csv -i0,1,4 -Fxm  > sybc_fit_north.txt
gmt gmtregress sybc_data_for_bestfit.csv -i0,2,5 -Fxm > sybc_fit_east.txt
gmt gmtregress sybc_data_for_bestfit.csv -i0,3,6 -Fxm > sybc_fit_vertical.txt

gmt begin SYBC_plot png
 gmt subplot begin 3x1 -Ff35c/50c -A+o-1c/-1.5c -M1c/2c --FONT_ANNOT_PRIMARY=15p,Helvetica -T"SYBC"
  # plot the north component
  gmt subplot set 0 -A"Reference latitude: 27.81@.N"
  gmt basemap -R2011/2017/-7/5 -BWrbt -Bxa0f0+l"Time (Year)" -Bya2f1+l"North (cm)" --FONT_LABEL=30p,Helvetica-Bold --MAP_TICK_LENGTH_PRIMARY=6p/3p
  gmt plot $input_file -i0,1+s100,4+s100 -Sc0.6c -Gblue -Wthinner -Ey+p0.01p,grey
  gmt plot sybc_fit_north.txt -i0,1+s100 -W2p,red
  gmt plot -W2p,purple << EOF
    $earthquake_date -1000
    $earthquake_date 1000
EOF
  gmt basemap -R2011-01-01/2017-01-01/-7/5 -f0T -Bxa1Yf1o+l"Time (Year)" -Bya2f1+l"North (cm)" --FONT_LABEL=30p,Helvetica-Bold --MAP_TICK_LENGTH_PRIMARY=6p/3p

  #plot the east component
  gmt subplot set 1 -A"Reference longitude: 85.71@.E"
  gmt basemap -R2011/2017/-12/8 -BWrbt -Bxa0f0+l"Time (Year)" -Bya4f1+l"East (cm)" --FONT_LABEL=30p,Helvetica-Bold --MAP_TICK_LENGTH_PRIMARY=6p/3p
  gmt plot $input_file -i0,2+s100,5+s100 -Sc0.6c -Gblue -Wthinner -Ey+p1p,grey
  gmt plot sybc_fit_east.txt -i0,1+s100 -W2p,brown
  gmt plot -W2p,purple << EOF
    $earthquake_date -1000
    $earthquake_date 1000
EOF
  gmt basemap -R2011-01-01/2017-01-01/-12/8 -f0T -Bxa1Yf1o+l"Time (Year)" -Bya4f1+l"East (cm)" --FONT_LABEL=30p,Helvetica-Bold --MAP_TICK_LENGTH_PRIMARY=6p/3p

  #plot the vertical component
  gmt subplot set -A"Reference ellipsoid height: 3794.2476 m"
  gmt basemap -R2011/2017/-4/4 -BWrbt -Bxa0f0+l"Time (Year)" -Bya1f1+l"Up (cm)" --FONT_LABEL=30p,Helvetica-Bold --MAP_TICK_LENGTH_PRIMARY=6p/3p
  gmt plot $input_file -i0,3+s100,6+s100 -Sc0.6c -Gblue -Wthinner -Ey+p1p,grey
  gmt plot sybc_fit_vertical.txt -i0,1+s100 -W2p,green
  gmt plot -W2p,purple << EOF
    $earthquake_date -1000
    $earthquake_date 1000
EOF
  gmt basemap -R2011-01-01/2017-01-01/-4/4 -f0T -Bxa1Yf1o+l"Time (Year)" -Bya1f1+l"Up (cm)" --FONT_LABEL=30p,Helvetica-Bold --MAP_TICK_LENGTH_PRIMARY=6p/3p

 gmt subplot end
gmt end show

#calculation of the slope 
