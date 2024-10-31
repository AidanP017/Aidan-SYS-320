#!/bin/bash

file="/var/log/apache2/access.log"

function countingCurlAccess(){
curlCount=$(cat "$file" | awk '{print $1, $12}' | grep "curl/7.81.0" | sort | uniq -c | sort -nr)
}

countingCurlAccess
echo "$curlCount"

