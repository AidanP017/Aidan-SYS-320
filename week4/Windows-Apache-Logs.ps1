# List all of the Apache logs of XAMPP
Get-Content C:\xampp\apache\logs\access.log
#_________________________________________#

# List only the last 5 Apache logs
Get-Content C:\xampp\apache\logs\access.log -Tail 5
#_________________________________________________#

# Display only logs that contain 404 (Not Found) or 400 (Bad Request)
Get-Content C:\xampp\apache\logs\access.log | Select-String ' 404 ',' 400 '
#_________________________________________________________________________#

# Display only logs that do not contain 200 (OK)
Get-Content C:\xampp\apache\logs\access.log | Select-String ' 200 ' -NotMatch
#___________________________________________________________________________#

# From every .log file in the directory, only get logs that contains the word 'error'
$A = Get-ChildItem -Path C:\xampp\apache\logs\*.log | Select-String 'error'
# Display the last 5 elements of the result array
$A[-5..-1]
#___________________________________________________________________________________#

# Get only logs that contain 404, save into $notfounds
$notfounds = Get-Content C:\xampp\apache\logs\access.log | Select-String ' 404 '
# Define a regex for IP addresses
$regex = [regex] "[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}"
# Get $notfounds records that match to the regex
$ipsUnorganized = $regex.Matches($notfounds)
# Get IPs as PSCustomObject
$ips = @()
for($i=0; $i -lt $ipsUnorganized.Count; $i++){
 $ips += [PSCustomObject]@{ "IP" = $ipsUnorganized[$i].Value; }
}
$ips | Where-Object { $_.IP -ilike "10.*" }
#______________________________________________________________________________#

# Count IPs from Number 8
$ipsoftens = $ips | Where-Object { $_.IP -ilike "10.*" }
$counts = $ipsoftens | Group-Object {$_.IP}
$counts | Select-Object Count, Name