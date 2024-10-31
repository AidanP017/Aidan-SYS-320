#!/bin/bash

function curl_loop {
	for i in {1..20}; do
		curl 10.0.17.26
	done
}

curl_loop
