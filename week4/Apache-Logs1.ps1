# Write a function that performs the following:
# 1. Parses Apache logs word by word into a PSCustomObject.
# 2. Filters the IP property of the return object for the 10.* network.

# Create the function
function ApacheLogs1(){

# Get content from the logs
$logsNotformatted = Get-Content C:\xampp\apache\logs\access.log

# Create the array
$tableRecords = @()
for($i=0; $i -lt $logsNotformatted.Count; $i++){

# Split a string into words
$words = $logsNotformatted[$i].Split(" ");

# Define the PSCustomObject
 $tableRecords += [PSCustomObject]@{ "IP" = $words[0]; `
                                     "Time" = $words[3].Trim('['); `
                                     "Method" = $words[5].Trim('"'); `
                                     "Page" = $words[6]; `
                                     "Protocol" = $words[7]; `
                                     "Response" = $words[8]; `
                                     "Referrer" = $words[10]; `
                                     "Client" = $words[11..($words.Length - 1)]; }
}
# Return the results that include IP properties for the 10.* network
return $tableRecords | Where-Object { $_.IP -ilike "10.*" }
}
$tableRecords = ApacheLogs1
$tableRecords | Format-Table -AutoSize -Wrap