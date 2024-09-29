# Calls the function "gatherClassess" from the file "scraping.ps1" and returns a table of results.
. (Join-Path $PSScriptRoot '.\scraping.ps1')
clear

# Call the function
$callClasses = gatherClasses
$callClasses
#________________________________________________________________________________________________#

# Calls the function "daysTranslator($fullTable)" from the file "scraping.ps1" and return a table.
. (Join-Path $PSScriptRoot '.\scraping.ps1')
clear

# Call the function
$translateDays = daysTranslator($fullTable)
$translateDays
#________________________________________________________________________________________________#

# List all of the classes of instructor Furkan Paligu.
$FullTable = daysTranslator($fullTable)
$FullTable | Select-Object "Class Code", Instructor, Location, Days, "Time Start", "Time End" | `
where {$_."Instructor" -ilike "Furkan*"}
#___________________________________________________________________________________________________________#

# List all of the classes of JOYC 310 on Mondays, only display class code and times. Then sort by start time.
$FullTable | Where-Object {($_.Location -ilike "JOYC 310") -and ($_.Days -match "Monday")} | `
Sort-Object "Time Start" | Select-Object "Time Start", "Time End", "Class Code"
#_____________________________________________________________________________________________________________________________________________#

# Make a list of all of the instructors that teach at least 1 course in SYS, SEC, NET, FOR, CSI, and DAT. Then sort by name and make it unique.
$ITSInstructors = $FullTable | Where-Object {($_."Class Code" -ilike "SYS*") -or `
                                             ($_."Class Code" -ilike "NET*") -or `
                                             ($_."Class Code" -ilike "SEC*") -or `
                                             ($_."Class Code" -ilike "FOR*") -or `
                                             ($_."Class Code" -ilike "CSI*") -or `
                                             ($_."Class Code" -ilike "DAT*")} `
                             | Select-Object "Instructor" `
                             | Sort-Object "Instructor" -unique
$ITSInstructors
#_____________________________________________________________________________________________________________________________________________#

# Group all of the instructors by the number of classes they are teaching.
$ITSInstructors = $FullTable | Where-Object {($_."Class Code" -ilike "SYS*") -or `
                                             ($_."Class Code" -ilike "NET*") -or `
                                             ($_."Class Code" -ilike "SEC*") -or `
                                             ($_."Class Code" -ilike "FOR*") -or `
                                             ($_."Class Code" -ilike "CSI*") -or `
                                             ($_."Class Code" -ilike "DAT*")} `
                             | Select-Object "Instructor" `
                             | Sort-Object "Instructor" -unique

$FullTable | Where {$_.Instructor -in $ITSInstructors.Instructor} `
           | Group-Object "Instructor" | Select-Object Count, Name | Sort-Object Count -Descending