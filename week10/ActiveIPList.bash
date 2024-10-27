#!/bin/bash

# Pings all of the IP addresses in the given network prefix of /24.

# Usage: bash IPList.bash 10.0.17
if [ "$#" -ne 1 ]; then
	echo "Usage: $0 <Prefix>"
	exit 1
fi

# Prefix is the first input taken.
prefix=$1

# Verify input length.
if [ "${#prefix}" -lt 5 ]; then
	printf "Prefix length is too short\nPrefix example: 10.0.17\n"
	exit 1
fi

for i in {1..254};
do
	ip="${prefix}.${i}"
	# Ping the IP addresses in the network and return those that are active.
	if ping -c 1 -W 1 $ip &> /dev/null; then
		echo "$ip"
	fi
done

