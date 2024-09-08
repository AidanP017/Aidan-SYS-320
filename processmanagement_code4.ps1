# Checks for one of two instances of this script:
# If an instance of this script is running already, stop it.
$pathToexecute = "C:\Program Files\Google\Chrome\Application\chrome.exe"
$startPage = "https://www.champlain.edu"
$data = "--user-data-dir=c:\temp"
if ($pathToexecute -eq $pathToexecute){
    Get-Process -Name chrome | Stop-Process}
# If an instance of this script is not running already, it starts Google Chrome web
# browser and directs to Champlain.edu.
if ($pathToexecute -notcontains "chrome.exe"){
    Start-Process -FilePath $pathToexecute $startPage}