. (Join-Path $PSScriptRoot Users.ps1)
. (Join-Path $PSScriptRoot Event-Logs.ps1)

clear

$Prompt = "`n"
$Prompt += "Please choose your operation:`n"
$Prompt += "1 - List Enabled Users`n"
$Prompt += "2 - List Disabled Users`n"
$Prompt += "3 - Create a User`n"
$Prompt += "4 - Remove a User`n"
$Prompt += "5 - Enable a User`n"
$Prompt += "6 - Disable a User`n"
$Prompt += "7 - Get Log-In Logs`n"
$Prompt += "8 - Get Failed Log-In Logs`n"
$Prompt += "9 - List At Risk Users`n"
$Prompt += "10 - Exit`n"



$operation = $true

while($operation){

    
    Write-Host $Prompt | Out-String
    $choice = Read-Host 


    if($choice -eq 10){
        Write-Host "Goodbye" | Out-String
        exit
        $operation = $false 
    }

    elseif($choice -eq 1){
        $enabledUsers = getEnabledUsers
        Write-Host ($enabledUsers | Format-Table | Out-String)
    }

    elseif($choice -eq 2){
        $notEnabledUsers = getNotEnabledUsers
        Write-Host ($notEnabledUsers | Format-Table | Out-String)
    }


    # Create a user
    elseif($choice -eq 3){ 

        $name = Read-Host -Prompt "Please enter the username for the new user"
        $password = Read-Host -AsSecureString -Prompt "Please enter the password for the new user"

        # TODO: Create a function called checkUser in Users that: 
        #              - Checks if user a exists. 
        #              - If user exists, returns true, else returns false
        # TODO: Check the given username with your new function.
        #              - If false is returned, continue with the rest of the function
        #              - If true is returned, do not continue and inform the user

        $Usercheck = checkUser $name
            if($Usercheck -eq $true){
                Write-Host "The user '$name' already exists."
                continue
            }
            elseif($Usercheck -eq $false){
                Write-Host "The user '$name' does not exist."
        }
        $Usercheck

        #
        # TODO: Create a function called checkPassword in String-Helper that:
        #              - Checks if the given string is at least 6 characters
        #              - Checks if the given string contains at least 1 special character, 1 number, and 1 letter
        #              - If the given string does not satisfy conditions, returns false
        #              - If the given string satisfy the conditions, returns true
        # TODO: Check the given password with your new function. 
        #              - If false is returned, do not continue and inform the user
        #              - If true is returned, continue with the rest of the function

        $Passwordcheck = checkPassword $password
            if ($Passwordcheck -eq $true){
                Write-Host "The password satisfied the requirements for $name. Created."
            }
            elseif ($Passwordcheck -eq $false){
                Write-Host "The password did not satisfy the requirements for $name. Not created."
                continue
        }

        createAUser $name $password

        Write-Host "User: $name is created." | Out-String
    }

    # Remove a user
    elseif($choice -eq 4){

        $name = Read-Host -Prompt "Please enter the username for the user to be removed"

        # TODO: Check the given username with the checkUser function.

        $Userremove = checkUser $name
            if($Userremove -eq $true){
                removeAUser $name
                Write-Host "The user '$name' was removed." | Out-String
                continue
            }
            elseif($Userremove -eq $false){
                Write-Host "The user '$name' does not exist and could not be removed."
        }
    }


    # Enable a user
    elseif($choice -eq 5){


        $name = Read-Host -Prompt "Please enter the username for the user to be enabled"

        # TODO: Check the given username with the checkUser function.

        $Userenable = checkUser $name
            if($Userenable -eq $true){
                enableAUser $name
                Write-Host "The user '$name' was enabled." | Out-String
                continue
            }
            elseif($Userenable -eq $false){
                Write-Host "The user '$name' does not exist and could not be enabled."
        }
    }


    # Disable a user
    elseif($choice -eq 6){

        $name = Read-Host -Prompt "Please enter the username for the user to be disabled"

        # TODO: Check the given username with the checkUser function.

        $Userdisable = checkUser $name
            if($Userdisable -eq $true){
                disableAUser $name
                Write-Host "The user '$name' was disabled." | Out-String
                continue
            }
            elseif($Userdisable -eq $false){
                Write-Host "The user '$name' does not exist and could not be disabled."
        }
    }


    elseif($choice -eq 7){

        $name = Read-Host -Prompt "Please enter the username for the user logs"

        # TODO: Check the given username with the checkUser function.

        $Userlogs = checkUser $name
            if($Userlogs -eq $true){
                Write-Host "The user '$name' exists. Fetching logs if available..."
                $userLogins = getLogInAndOffs 90
                Write-Host ($userLogins | Where-Object { $_.User -ilike "*$name"} | `
                Format-Table | Out-String)
                continue
            }
            elseif($Userlogs -eq $false){
                Write-Host "Can not find logs for the user '$name'. Does not exist."
        }
        # TODO: Change the above line in a way that, the days 90 should be taken from the user
    }


    elseif($choice -eq 8){

        $name = Read-Host -Prompt "Please enter the username for the user's failed login logs"

        # TODO: Check the given username with the checkUser function.

        $Userfails = checkUser $name
            if($Userfails -eq $true){
                Write-Host "The user '$name' exists. Fetching logs if available..."
                $userLogins = getFailedLogins 90
                Write-Host ($userLogins | Where-Object { $_.User -ilike "*$name"} | `
                Format-Table | Out-String)
                continue
            }
            elseif($Userfails -eq $false){
                Write-Host "Can not find logs for the user '$name'. Does not exist."
        }
        # TODO: Change the above line in a way that, the days 90 should be taken from the user
    }


    # TODO: Create another choice "List at Risk Users" that
    #              - Lists all the users with more than 10 failed logins in the last <User Given> days.  
    #                (You might need to create some failed logins to test)
    #              - Do not forget to update prompt and option numbers

    elseif($choice -eq 9){

        $name = Read-Host -Prompt "Please enter the number of days for which to obtain this information"
        Write-Host "Fetching information..."
        $userLogins = getFailedLogins $name
        $userLogins | Group-Object "User" | Where-Object {$_.Count -gt 10}
        continue
    }

    # TODO: If user enters anything other than listed choices, e.g. a number that is not in the menu   
    #       or a character that should not be accepted. Give a proper message to the user and prompt again.

    elseif($choice -ne "[1-10]" -or $choice -ne "[a-zA-Z]" -or $choice -ne "[\W_]"){
        Write-Host "This is not a proper choice. Please try again."
        continue
        }
}