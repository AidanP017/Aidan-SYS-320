#!/bin/bash

# List all the IPs in the given network prefix

# Usage: bash IPList.bash 10.0.17
if [ "$#" -ne 1 ]; then
	echo "Usage: $0 <Prefix>"
	exit 1
fi

# Prefix is the first input taken.
prefix=$1

# Verify input length
if [ "${#prefix}" -lt 5 ]; then
	printf "Prefix length is too short\nPrefix example: 10.0.17\n"
	exit 1
fi

for i in {1..254}
do
	echo "$prefix.$i"
done

