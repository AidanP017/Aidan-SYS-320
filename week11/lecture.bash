#!/bin/bash

file="/var/log/apache2/access.log"

results=$(cat "$file" | cut -d' ' -f1,7 | grep "page2.html" | tr -d "[")

echo "$results"
#______________________________________________________________________#

function pageCount(){
countPages=$(cat "$file" | awk '{print $7}' | sort | uniq -c | sort -nr)
}

pageCount
echo "$countPages"
