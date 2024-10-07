. (Join-Path $PSScriptRoot "C:\Users\champuser\Aidan-SYS-320\week6\main.ps1")
. (Join-Path $PSScriptRoot Apache-Logs1.ps1)
. (Join-Path $PSScriptRoot Event-Logs.ps1)
. (Join-Path $PSScriptRoot "C:\Users\champuser\Aidan-SYS-320\week2\processmanagement.ps1")

clear

$Prompt = "`n"
$Prompt += "Please select an option:`n"
$Prompt += "1 - Display the last 10 Apache logs`n"
$Prompt += "2 - Display the last 10 failed login attempts for all users`n"
$Prompt += "3 - Display all of the users that are at risk`n"
$Prompt += "4 - Start or stop Google Chrome and navigate to champlain.edu`n"
$Prompt += "5 - Exit`n"

$operation = $true

while($operation){

    
    Write-Host $Prompt | Out-String
    $choice = Read-Host

    if($choice -eq 5){
        Write-Host "Exiting menu. Goodbye." | Out-String
        exit
        $operation = $false 
    }
    
    elseif($choice -eq 1){
        Write-Host "Fetching logs..."
        $lastLogs = ApacheLogs1 | Select-Object -Last 10
        $lastlogs | Format-Table -AutoSize -Wrap
    }

    elseif($choice -eq 2){
        Write-Host "Fetching information..."
        $lastFailedLogins = getFailedLogins 90
        $lastFailedLogins | Select-Object -First 10 | Format-Table -AutoSize -Wrap
    }

    elseif($choice -eq 3){
        Write-Host "Fetching information..."
        $riskedUsers = getFailedLogins 90
        $riskedUsers | Select-Object "User" -Unique | Format-Table -AutoSize -Wrap
    }

    elseif($choice -eq 4){
        Write-Host "Opening or closing Google Chrome and navigating to champlain.edu..."
        $accessChrome = chromeExecute
    }

    elseif($choice -ne "[1-10]" -or $choice -ne "[a-zA-Z]" -or $choice -ne "[\W_]"){
        Write-Host "That is not a proper selection. Please try again."
    }
}