# Calls the function "ApacheLogs" from the file "Apache-Logs.ps1" and counts the IP addresses
. (Join-Path $PSScriptRoot '.\Apache-Logs.ps1')
clear

# Define the user inputs
$pageVisited = Read-Host "Enter the page visited or referred from"
$codeHTTP = Read-Host "Enter the HTTP code returned"
$nameofbrowser = Read-Host "Enter the name of the web browser"

# Call the function with the parameters
$ipsamount = ApacheLogs $pageVisited $codeHTTP $nameofbrowser
$ipsamount