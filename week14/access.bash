#!/bin/bash

# Access the log file
logFile="/home/champuser/Aidan-SYS-320/week14/fileaccesslog.txt"

# Obtain the date and time information
timestamp=$(date "+%a %b %d %I-%M-%S %p")

# Append the timestamp to the log file
echo "$timestamp" >> "$logFile"

# Send the log contents as an email using ssmtp
cat "$logFile" | ssmtp aidan.pasek@mymail.champlain.edu
