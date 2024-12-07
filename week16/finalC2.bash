#!/bin/bash

# Check for the correct number of arguments
if [ $# -ne 2 ]; then
	echo "Usage: $0 access.log ioc.txt"
	exit 1
fi

# Define the arguments
accessLog="$1"
iocFile="$2"
savedContent="report.txt"

# Specify the report file to create
> "$savedContent"

# Obtain the IOCs in the text file
while IFS= read -r ioc; do
	if [[ -z "$ioc" || "$ioc" =~ ^# ]]; then
		continue
	fi
	
	# Search for the matching entries and extract the desired entries
	grep -i "$ioc" "$accessLog" | while read -r line; do
		ip=$(echo "$line" | awk '{print $1}')
		datetime=$(echo "$line" | awk -F '[][]' '{print $2}' | sed 's/ [^ ]*$//')
		page=$(echo "$line" | awk '{print $7}')

		# Save the entries to the report file
		echo "$ip $datetime $page" >> "$savedContent"
	done
done < "$iocFile"

# Output a message if successful
echo "Report saved to $savedContent."
