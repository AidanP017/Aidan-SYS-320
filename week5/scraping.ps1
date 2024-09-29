# Write a function that scrapes the table from "Courses.html" and saves the content to a custom object.

# Create the function
function gatherClasses(){
$page = Invoke-WebRequest -TimeoutSec 2 http://10.0.17.19/Courses.html

# Get all of the "tr" elements of the HTML document.
$trs = $page.ParsedHtml.body.getElementsByTagName("tr")

# Create an empty array to hold results.
$fullTable = @()
for($i=1; $i -lt $trs.Length; $i++){

    # Get every "td" element of the current "tr" element.
    $tds = $trs[$i].getElementsByTagName("td")

    # Separate the start and end times.
    $Times = $tds[5].innerText.Split("-")
    
    # Define the custom object.
    $fullTable += [PSCustomObject]@{"Class Code" = $tds[0].innerText; `
                                         "Title" = $tds[1].innerText; `
                                          "Days" = $tds[4].innerText; `
                                    "Time Start" = $Times[0]; `
                                      "Time End" = $Times[1]; `
                                    "Instructor" = $tds[6].innerText; `
                                      "Location" = $tds[9].innerText; `
                                   }
}
return $fullTable
}
#_____________________________________________________________________________________________________#

# Write a translator function that accomplishes the following tasks:
# 1. Takes the table returned from the function "gatherClasses".
# 2. Replaces the "Days" property with an actual array of days.
# 3. Returns the renewed table.

# Create the function and reuse the elements of the previous function.
function daysTranslator($fullTable){
$page = Invoke-WebRequest -TimeoutSec 2 http://10.0.17.19/Courses.html

# Get all of the "tr" elements of the HTML document.
$trs = $page.ParsedHtml.body.getElementsByTagName("tr")

# Create an empty array to hold results.
$fullTable = @()
for($i=1; $i -lt $trs.Length; $i++){

    # Get every "td" element of the current "tr" element.
    $tds = $trs[$i].getElementsByTagName("td")

    # Separate the start and end times.
    $Times = $tds[5].innerText.Split("-")
    
    # Define the custom object.
    $fullTable += [PSCustomObject]@{"Class Code" = $tds[0].innerText; `
                                         "Title" = $tds[1].innerText; `
                                          "Days" = $tds[4].innerText; `
                                    "Time Start" = $Times[0]; `
                                      "Time End" = $Times[1]; `
                                    "Instructor" = $tds[6].innerText; `
                                      "Location" = $tds[9].innerText; `
                                   }
}
# Go over every record in the table.
for($i=0; $i -lt $fullTable.length; $i++){

    # Create an empty array to hold the days for every record.
    $Days = @()

    # If you see "M" -> Monday
    if($fullTable[$i].Days -ilike "*M"){$Days += "Monday"}

    # If you see "T" followed by T, W, or F -> Tuesday
    if($fullTable[$i].Days -ilike "*T[TWF]*"){$Days += "Tuesday"}
    # If you only see "T" -> Tuesday
    ElseIf($fullTable[$i].Days -ilike "T"){$Days += "Tuesday"}

    # If you see "W" -> Wednesday
    if($fullTable[$i].Days -ilike "*W"){$Days += "Wednesday"}

    # If you see "Th" -> Thursday
    if($fullTable[$i].Days -ilike "*Th*"){$Days += "Thursday"}

    # If you see "F" -> Friday
    if($fullTable[$i].Days -ilike "*F"){$Days += "Friday"}

    # Make the switch
    $fullTable[$i].Days = $Days
}
return $fullTable
}