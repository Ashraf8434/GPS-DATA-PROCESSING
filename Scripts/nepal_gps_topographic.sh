

input_file=glredts.vel
output=map_topo_nepal.ps
region=83/90/25.5/30
projection=M25c 
# Define the topography file
gmt grdcut @earth_relief_01m -R$region -Gnepal_relief.nc

# Define the color palette for topography
cpt=topo.cpt

# Create the color palette
gmt makecpt -Cglobe -T0/9000/100 > $cpt

gmt begin nepal_gps_vectors jpg  
#gmt set FONT_Title 18p,Helvetica-Bold -T"Topography of Nepal"
  # Plot topography with shading
  gmt grdimage nepal_relief.nc -R$region -J$projection -C$cpt -I+a
  #gmt coast -R$region -J$projection -Gwhite -Sblue -W0.5p,yellow -Df -N1/0.5p,red -I1/0.5p,blue
 # gmt coast -R$region -J$projection -B -G
  gmt basemap -BWSen -Bx2g2 -By2g2 --MAP_FRAME_TYPE=fancy
  #Plotting the gps velocity vectors
  gmt velo $input_file -R$region -J$projection -Se0.03c/1/1 -A0.5c+e+p1.5p,black -Gblue
  #Plotting of stations data
  gmt text station.txt -R$region -J$projection -F+f15p,Helvetica-Bold,black+jTL
  gmt plot station.txt -R$region -J$projection -Sd0.3c -Gred -W0.5p,black

  gmt colorbar -DjTC+w10c/0.5c+o0/1c+h -Bx+l"Elevation (m)" -By+lm

  #gmt colorbar -DjTC+w10c/0.5c+o0/1c+h -Bx+l"Elevation (m)" -By+lm
  
gmt end show
