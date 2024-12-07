#!/bin/bash

# Define the location for the HTML report file
htmlReport="/var/www/html/report.html"

# Create the HTML structure
cat <<EOF > "$htmlReport"
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <style>
	body { font-family: Arial, sans-serif; margin: 20px; font-size: 15px; }
	h1 { color: #333; }
	table { width: 100%; border-collapse; collapse; margin-top: 20px; }
	th, td { padding: 8px 12px; border: 1px solid #ddd; text-align: left; font-size: 12px; }
	th { background-color: #f4f4f4; }
	tr:nth-child(even) { background-color: #f9f9f9; }
    </style>
</head>
<body>
    <h1>Access logs with IOC indicators:</h1>
    <table>
	<tbody>
EOF

# Read report.txt and add the desired lines to the HTML table
while IFS= read -r line; do
	if [[ -n "$line" ]]; then
		echo " <tr><td>${line// /</td><td>}</td></tr>" >> "$htmlReport"
	fi
done < report.txt

# Close the HTML tags
cat <<EOF >> "$htmlReport"
	</tbody>
    </table>
</body>
</html>
EOF

# Output a message if successful
echo "HTML report generated at $htmlReport."
