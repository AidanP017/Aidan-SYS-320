<# String-Helper
*************************************************************
   This script contains functions that help with String/Match/Search
   operations. 
************************************************************* 
#>

<# ******************************************************
   Functions: Get Matching Lines
   Input:   1) Text with multiple lines  
            2) Keyword
   Output:  1) Array of lines that contain the keyword
********************************************************* #>
function getMatchingLines($contents, $lookline){

$allines = @()
$splitted =  $contents.split([Environment]::NewLine)

for($j=0; $j -lt $splitted.Count; $j++){  
 
   if($splitted[$j].Length -gt 0){  
        if($splitted[$j] -ilike $lookline){ $allines += $splitted[$j] }
   }

}

return $allines
}


function checkPassword(){
    param(
        [Parameter(Mandatory=$true)]
        [SecureString]$pass
    )
    $specialCharacters = "!@#$%^&*()-_=+,.<>/\"

    $bstr = [System.Runtime.InteropServices.Marshal]::SecureStringToBSTR($pass)
    $Password = [System.Runtime.InteropServices.Marshal]::PtrToStringAuto($bstr)

    if ($Password.Length -lt 6){
        return $false
    }
    foreach ($character in $specialCharacters){
        if ($Password -notmatch '[\W_]'){
            return $false
        }
    }
    if ($Password -notmatch '\d'){
        return $false
    }
    if ($Password -notmatch '[a-zA-Z]'){
        return $false
    }
    else{
        return $true
    }
}