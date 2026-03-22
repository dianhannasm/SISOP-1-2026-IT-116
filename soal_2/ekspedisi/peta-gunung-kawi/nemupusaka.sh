#!/bin/bash

lat1=$(sed -n '1p' titik-penting.txt | awk -F',' '{print $3}')
lon1=$(sed -n '1p' titik-penting.txt | awk -F',' '{print $4}')

lat3=$(sed -n '3p' titik-penting.txt | awk -F',' '{print $3}')
lon3=$(sed -n '3p' titik-penting.txt | awk -F',' '{print $4}')

mid_lat=$(echo "($lat1 + $lat3)/2" | bc -l)
mid_lon=$(echo "($lon1 + $lon3)/2" | bc -l)

printf "Koordinat pusat:\n%.5f, %.5f\n" $mid_lat $mid_lon > posisipusaka.txt
