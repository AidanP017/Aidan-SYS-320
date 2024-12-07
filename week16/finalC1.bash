#!/bin/bash

# Specify the URL to obtain content
url="10.0.17.6/ioc.html"

# Specify the text file to create
textFile="ioc.txt"

# Obtain the content and save it to a temporary file
curl -s "$url" > content.html

# Obtain the patterns
patterns=("etc/passwd" "cmd=" "/bin/bash" "/bin/sh" "1=1#" "1=1--")

# Create the text file to save the patterns
> "$textFile"

# Search for the patterns and save them to the text file
for pattern in "${patterns[@]}"; do
	grep -o -i "$pattern" content.html >> "$textFile"
done

# Remove the temporary file
rm content.html

# Output a message if successful
echo "IOC patterns saved to $textFile."
