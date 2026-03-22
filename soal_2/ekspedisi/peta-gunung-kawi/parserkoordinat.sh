#!/bin/bash

awk -F'"' '
/"id"/ {
id=$0
gsub(/.*"id": "/, "", id)
gsub(/",?/, "", id)
}
/"site_name"/ {
site=$0
gsub(/.*"site_name": "/, "", site)
gsub(/",?/,"", site)
}
/"latitude"/ {
lat=$0
gsub(/.*"latitude": /, "", lat)
gsub(/,/, "", lat)
}
/"longitude"/ {
lon=$0
gsub(/.*"longitude": /, "", lon)
gsub(/,/, "", lon)

printf "%s, %s, %s, %s\n", id, site, lat, lon
}
' gsxtrack.json > titik-penting.txt
