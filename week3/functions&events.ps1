# Get login and logoff records from Windows Events
Get-EventLog System -source Microsoft-Windows-Winlogon
#________________________________________________________________________________________________#

# Get login and logoff records from Windows Events and save to a variable
$loginouts = Get-EventLog System -source Microsoft-Windows-Winlogon -After (Get-Date).AddDays(-14)
# Create an empty array to fill customly
$loginoutsTable = @()
for($i=0; $i -lt $loginouts.Count; $i++){
# Create an event property value
$event = ""
if($loginouts[$i].InstanceId -eq 7001) {$event="Logon"}
if($loginouts[$i].InstanceId -eq 7002) {$event="Logoff"}
# Create a user property value
$user = $loginouts[$i].ReplacementStrings[1]
# Adding each new line (in form of a custom object) to the empty array
$loginoutsTable += [pscustomobject]@{"Time" = $loginouts[$i].TimeGenerated; `
                                       "Id" = $loginouts[$i].InstanceId; `
                                    "Event" = $event; `
                                     "User" = $user;
                                     }
}
$loginoutsTable
#__________________________________________________________________________________________________________________________________________________________________________#

# Use System Security Principle SecurityIdentifier to translate the user Id to username.
$SID = "S-1-5-21-3457854727-680176579-2457243960-1002" # Define the SID to translate
$SIDobject = New-Object System.Security.Principal.SecurityIdentifier($SID) # Creates a new SecurityIdentifier object
$Userobject = $SIDobject.Translate([System.Security.Principal.NTAccount]) # Translates the SID to an NTAccount object
$user = $Userobject.Value # Outputs the username
$loginouts = Get-EventLog System -source Microsoft-Windows-Winlogon -After (Get-Date).AddDays(-14) # Get login and logoff records from Windows Events and save to a variable
# Create an empty array to fill customly
$loginoutsTable = @()
for($i=0; $i -lt $loginouts.Count; $i++){
# Create an event property value
$event = ""
if($loginouts[$i].InstanceId -eq 7001) {$event="Logon"}
if($loginouts[$i].InstanceId -eq 7002) {$event="Logoff"}
# Adding each new line (in form of a custom object) to the empty array
$loginoutsTable += [pscustomobject]@{"Time" = $loginouts[$i].TimeGenerated; `
                                       "Id" = $loginouts[$i].InstanceId; `
                                    "Event" = $event; `
                                     "User" = $user;
                                     }
}
$loginoutsTable
#__________________________________________________________________________________________________________________________________________________________________________#

# Turns the script into a function to accomplish the following:
# 1. Take an input variable and return the table of results.
# 2. The input variable is the number of days for which the logs will be obtained.
# 3. Call the function with the parameter and print the results on screen.

# Defines the SID to translate, translates to an NTAccount object, and outputs the username for the function
$SID = "S-1-5-21-3457854727-680176579-2457243960-1002"
$SIDobject = New-Object System.Security.Principal.SecurityIdentifier($SID)
$Userobject = $SIDobject.Translate([System.Security.Principal.NTAccount])
$user = $Userobject.Value
# Create the function
function Obtain-Logs {
    param (
        [int]$Days
    )
    # Calculate the start date based on the number of days
    $Startdate = (Get-Date).AddDays(-$Days)
    # Retrieve the necessary logs
    $logs = Get-EventLog -LogName System -Source Microsoft-Windows-Winlogon -After $Startdate
    # Create an empty array to fill customly
    $logsTable = @()
    for($i=0; $i -lt $logs.Count; $i++){
    # Create an event property value
    $event = ""
    if($logs[$i].InstanceId -eq 7001) {$event="Logon"}
    if($logs[$i].InstanceId -eq 7002) {$event="Logoff"}
    # Create custom objects for each record
    $loginoutsTable = $records | ForEach-Object {
        [PSCustomObject]@{
           "Time"  = $logs[$i].TimeGenerated; `
           "Id"    = $logs[$i].InstanceId; `
           "Event" = $event; `
           "User"  = $user;}
        }
    }
# Return the results
return $loginoutsTable
}
# Define the user input process
$days = Read-Host "Enter the number of days"
$result = Obtain-Logs -Days $days
$result | Format-Table -AutoSize
#__________________________________________________________________________________________________________#

# Turns the script into a function that obtains the computer's start and shutdown times.

# Create the function
function Obtain-Times {
    param (
        [string]$ComputerName = $env:COMPUTERNAME
    )
    # Obtain the start times
    $startTimes = Get-EventLog -LogName System -Source EventLog -ComputerName `
    $ComputerName | Where-Object {$_.EventID -eq 6005}
    # Obtain the shutdown times
    $shutdownTimes = Get-EventLog -LogName System -Source EventLog -ComputerName `
    $ComputerName | Where-Object {$_.EventID -eq 6006}
    # Combine the events and sort the results
    $events = $startTimes + $shutdownTimes | Sort-Object TimeGenerated
    # Create custom objects for each event
    $results = $events | ForEach-Object {
        [PSCustomObject]@{
            Time    = $_.TimeGenerated; `
            ID      = $_.EventID; `
            Event   = if ($_.EventID -eq 6005) {"Start"} else {"Shutdown"}; `
            User    = "System" `
        }
    }
    # Return the results
    $results | Format-Table -AutoSize
}
# Call the function
Obtain-Times