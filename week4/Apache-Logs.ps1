# Create a function that takes the following inputs:
# 1. The page visited or referred from on your Apache server.
# 2. The HTTP code returned.
# 3. The name of the web browser.
# The function will return one output:
# 1. The IP addresses that have visited the given page or referred from, with the given web browser,
#    and got the given HTTP response.
# The function itself will be called from a different file using dot notation.

# Create the function
function ApacheLogs {
    param (
        [string]$visitedPage,
        [int]$httpCode,
        [string]$browserName
    )
    # Specify the log path
    $logPath = "C:\xampp\apache\logs\access.log"
    # Get the content from the log path
    $logEntries = Get-Content $logPath
    $filteredEntries = $logEntries | Where-Object {
        $_ -match $visitedPage -and
        $_ -match $httpCode -and
        $_ -match $browserName
    }
    # Define the regex for IP addresses
    $regex = [regex] "[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}"
    # Get $filteredEntries records that match to the regex
    $ipsUnorganized = $regex.Matches($filteredEntries)
    # Get IPs as PSCustomObject
    $ips = @()
    for($i=0; $i -lt $ipsUnorganized.Count; $i++){
     $ips += [PSCustomObject]@{ "IP" = $ipsUnorganized[$i].Value; }
    }
    # Count the IP addresses and sort the results
    $count = $ips | Where-Object { $_.IP -ilike "10.*" }
    $counts = $count | Group-Object IP
    return $counts | Select-Object Count, Name
}
#$pageVisited = Read-Host "Enter the page visited or referred from"
#$codeHTTP = Read-Host "Enter the HTTP code returned"
#$nameofbrowser = Read-Host "Enter the name of the web browser"

#$IPs = ApacheLogs | Where-Object { $_.IP -ilike "10.*" }
#-visitedPage $pageVisited -httpCode $codeHTTP -browserName $nameofbrowser
#$count = $IPs | Group-Object {$_.IP}
#$count | Select-Object Count, Name