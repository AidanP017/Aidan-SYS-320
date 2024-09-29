# Get the link count from your web page.
$scraped_page = Invoke-WebRequest -TimeoutSec 10 http://10.0.17.19/ToBeScraped.html
$scraped_page.Links.Count
#_________________________________________________________________________________#

# Get the links as HTML elements.
$scraped_page.Links
#_______________________________#

# Get the links and display only the URL and its text.
$scraped_page.Links | Select outerText, href
#____________________________________________________#

# Get the outer text of every element with the tag "h2".
$scraped_page = Invoke-WebRequest -TimeoutSec 10 http://10.0.17.19/ToBeScraped.html
$h2s = $scraped_page.ParsedHtml.body.getElementsByTagName("h2") | Select outerText
$h2s
#_________________________________________________________________________________#

# Print the inner text of every div element that has the class as "div-1".
$scraped_page = Invoke-WebRequest -TimeoutSec 10 http://10.0.17.19/ToBeScraped.html
$divs1 = $scraped_page.ParsedHtml.body.getElementsByTagName("div") | Where `
{ $_.getAttributeNode("class").Value -ilike "div-1" } | Select innerText
$divs1