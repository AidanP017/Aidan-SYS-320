#!/bin/bash

myIP=$(bash myIP.bash)

# Todo-1: Create a helpmenu function that prints help for the script
function helpmenu(){
	echo ""
	echo "                     HELP MENU                         "
	echo "-------------------------------------------------------"
	echo "-n: Add -n as an argument for this script to use NMAP"
	echo " -n external: Performs an External NMAP scan"
	echo " -n internal: Performs an Internal NMAP scan"
	echo "-s: Add -s as an argument for this script to use SS"
	echo " -s external: Performs an External SS(Netstat) scan"
	echo " -s internal: Performs an Internal SS(Netstat) scan"
	echo ""
	echo "Usage: bash networkchecker.bash -n/-s external/internal"
	echo "-------------------------------------------------------"
	echo ""
}

# Return ports that are serving to the network
function ExternalNmap(){
  rex=$(nmap "${myIP}" | awk -F"[/[:space:]]+" '/open/ {print $1,$4}' )
}

# Return ports that are serving to localhost
function InternalNmap(){
  rin=$(nmap localhost | awk -F"[/[:space:]]+" '/open/ {print $1,$4}' )
}

# Only IPv4 ports listening from network
function ExternalListeningPorts(){

# Todo-2: Complete the ExternalListeningPorts that will print the port and application
# that is listening on that port from network (using ss utility)

	elpo=$(ss -ltpn | awk -F "[[:space:]]+" '{print $4,$6}' | grep -E "[0-9]{1,3}\." | \
	grep -v "127.0.0" | awk -F "[[:space:]:(),]+" '{print $2,$4}' | tr -d "\"")
	echo "$elpo"
}

# Only IPv4 ports listening from localhost
function InternalListeningPorts(){
	ilpo=$(ss -ltpn | awk  -F"[[:space:]:(),]+" '/127.0.0./ {print $5,$9}' | tr -d "\"")
	echo "$ilpo"
}

# Todo-3: If the program is not taking exactly 2 arguments, print helpmenu
if [ $# -ne 2 ]; then
	helpmenu
	exit 1
fi

# Todo-4: Use getopts to accept options -n and -s (both will have an argument)
# If the argument is not internal or external, call helpmenu
# If an option other then -n or -s is given, call helpmenu
# If the options and arguments are given correctly, call corresponding functions
# For instance: -n internal => will call NMAP on localhost
#               -s external => will call ss on network (non-local)
while getopts "n:s:" opt; do
	case $opt in
		n)
			if [[ "$OPTARG" == "internal" ]]; then
				InternalListeningPorts
			elif [[ "$OPTARG" == "external" ]]; then
				ExternalListeningPorts
			else
				helpmenu
				exit 1
			fi
			;;
		s)
			if [[ "$OPTARG" == "internal" ]]; then 
                                InternalListeningPorts
                        elif [[ "$OPTARG" == "external" ]]; then
                                ExternalListeningPorts
			else
				helpmenu
				exit 1
                        fi
                        ;;
		*)
			helpmenu
			exit 1
			;;
	esac
done
