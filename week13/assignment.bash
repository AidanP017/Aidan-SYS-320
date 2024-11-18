#!/bin/bash

# Define the webpage to scrape
URL="http://10.0.17.6/assignment.html"

# Download the webpage's HTML content
htmlContent=$(curl -s "$URL")

# Extract the data
datetimes=$(echo "$htmlContent" | grep -oP '(?<=<td>)[^<]+' | sed -n '2~2p')
temperatureTable=$(echo "$htmlContent" | sed -n '/<table.*id="temp">/,/<\/table>/p' | \
       	grep -oP '(?<=<td>)[^<]+' | sed -n '1~2p')
pressureTable=$(echo "$htmlContent" | sed -n '/<table.*id="press">/,/<\/table>/p' | \
	grep -oP '(?<=<td>)[^<]+' | sed -n '1~2p')

# Convert the data into arrays
datetime_array=($datetimes)
temperature_array=($temperatureTable)
pressure_array=($pressureTable)

# Count the number of lines
count=${#temperature_array[@]}

# Loop through each line and merge them
for ((i = 0; i < count; i++)); do
	datetime=$(echo "$datetimes" | head -n $((i+1)) | tail -n 1)
	pressure=$(echo "$pressureTable" | head -n $((i+1)) | tail -n 1)
	temperature=$(echo "$temperatureTable" | head -n $((i+1)) | tail -n 1)
	# Output the results
	echo "$pressure $temperature $datetime"
done
