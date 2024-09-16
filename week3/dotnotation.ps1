# Use dot notation to call functions from the file "functions&events.ps1" with certain conditions
. (Join-Path $PSScriptRoot '.\Aidan-SYS-320\week3\functions&events.ps1')
clear
# Get login and logoff records from the last 15 days
$loginoutsTable = Obtain-Logs -Days 15
$loginoutsTable
# Get start and shutdown records from the last 25 days
$timesTable = Obtain-Times -Days 25
$timesTable