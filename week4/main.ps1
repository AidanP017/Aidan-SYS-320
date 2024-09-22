# Calls the function "ApacheLogs" from the file "Apache-Logs.ps1" and counts the IP addresses
#. (Join-Path $PSScriptRoot '.\Apache-Logs.ps1')
#clear

## Define the user inputs
#$pageVisited = Read-Host "Enter the page visited or referred from"
#$codeHTTP = Read-Host "Enter the HTTP code returned"
#$nameofbrowser = Read-Host "Enter the name of the web browser"

## Call the function with the parameters
#$ipsamount = ApacheLogs $pageVisited $codeHTTP $nameofbrowser
#$ipsamount
#____________________________________________________________________________________________#

# Calls the function "ApacheLogs1" from the file "Apache-Logs1.ps1" with the appropriate tasks
. (Join-Path $PSScriptRoot '.\Apache-Logs1.ps1')
clear

$parsedIPs = ApacheLogs1
$parsedIPs | Format-Table -AutoSize -Wrap