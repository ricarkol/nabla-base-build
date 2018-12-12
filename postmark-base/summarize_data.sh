#!/bin/bash

(
	cd data
	for f in `ls *.tps`; do printf "%-50s " $f;  cat $f \
		| awk '{printf "%f\n", $1}' | st -nh --m --stddev; printf "\n"; done
)
