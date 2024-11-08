#! /bin/bash

logFile="/var/log/apache2/access.log.1"
mylogFile="/var/log/apache2/access.log"

function displayAllLogs(){
	cat "$logFile"
}

function displayOnlyIPs(){
        cat "$logFile" | cut -d ' ' -f 1 | sort -n | uniq -c
}

function displayOnlyPages(){
	cat "$logFile" | cut -d ' ' -f 5 | sort -n | uniq
}

function histogram(){

	local visitsPerDay=$(cat "$logFile" | cut -d " " -f 4,1 | tr -d '['  | sort \
                              | uniq)
	# This is for debugging, print here to see what it does to continue:
	# echo "$visitsPerDay"

        :> newtemp.txt  # what :> does is in slides
	echo "$visitsPerDay" | while read -r line;
	do
		local withoutHours=$(echo "$line" | cut -d " " -f 2 \
                                     | cut -d ":" -f 1)
		local IP=$(echo "$line" | cut -d  " " -f 1)
          
		local newLine="$IP $withoutHours"
		echo "$IP $withoutHours" >> newtemp.txt
	done 
	cat "newtemp.txt" | sort -n | uniq -c
}

function frequentVisitors(){
	cat "$mylogFile" | awk '{print $1, $4}' | sed 's/\[//g; s/\]//g' | \
	cut -d: -f1 | sort | uniq -c | awk '$1 > 10 {print $1, $2, $3}'
}

function suspiciousVisitors(){
	iocFile="/home/champuser/Aidan-SYS-320/week12/ioc.txt"
	grep -i -f "$iocFile" "$mylogFile" | awk '{print $1}' | sort | uniq -c
}

# Keep in mind that I have selected long way of doing things to 
# demonstrate loops, functions, etc. If you can do things simpler,
# it is welcomed.

while :
do
	echo "PLease select an option:"
	echo "[1] Display All Logs"
	echo "[2] Display Only IPs"
	echo "[3] Display Only Pages"
	echo "[4] Show Histogram"
	echo "[5] Show Frequent Visitors"
	echo "[6] Show Suspicious Visitors"
	echo "[7] Quit"

	read userInput
	echo ""

	if [[ "$userInput" == "7" ]]; then
		echo "Goodbye"		
		break

	elif [[ "$userInput" == "1" ]]; then
		echo "Displaying all logs:"
		displayAllLogs

	elif [[ "$userInput" == "2" ]]; then
		echo "Displaying only IPs:"
		displayOnlyIPs

	elif [[ "$userInput" == "3" ]]; then
		echo "Displaying only pages:"
		displayOnlyPages

	elif [[ "$userInput" == "4" ]]; then
		echo "Showing histogram:"
		histogram

	elif [[ "$userInput" == "5" ]]; then
		echo "Showing frequent visitors:"
		frequentVisitors

	elif [[ "$userInput" == "6" ]]; then
		echo "Showing suspicious visitors:"
		suspiciousVisitors

	else
		echo "This is not a valid input. Please try again."
	fi
done

