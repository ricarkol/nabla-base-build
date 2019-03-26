#!/bin/bash

# Example:
# bash run_single_nabla.sh read5.med pm_data log.lfs

# Location should be empty!!!

workload=$1
location=$2
logfile=$3
keep=$4

{
	echo workload=$1
	echo location=$2
	echo logfile=$3
	echo keep=$3

	mkdir -p ${location}

	# if keep is not defined
	if [ -z $3 ]; then
		rm -rf ${location}/s[0-9]*
		rm -rf ${location}/[0-9]*
	fi

	echo "set location /pm_data" > ${location}/benchmark.${workload}
	grep -v "set location" benchmark.${workload} >> ${location}/benchmark.${workload}

	ts=$(date +%s%N)
	time ../solo5/tests/test_blk/ukvm-bin --dir=${location} --log=${logfile} postmark-split.nabla '{"cmdline":"bin/postmark.nabla /pm_data/benchmark.'${workload}'","blk":{"source":"etfs","path":"/dev/ld0a","fstype":"blk","mountpoint":"/pm_data"}}'
	#time ../solo5/ukvm/ukvm-bin --dir=${location} --log=${logfile} --net=tap100 postmark-split.nabla '{"cmdline":"bin/postmark.nabla /pm_data/benchmark.'${workload}'","net":{"if":"ukvmif0","cloner":"True","type":"inet","method":"static","addr":"10.0.0.2","mask":"16"},"blk":{"source":"etfs","path":"/dev/ld0a","fstype":"blk","mountpoint":"/pm_data"}}'
	tx=`grep transactions benchmark.${workload} | awk '{print $3}'`
	tn=$((($(date +%s%N) - $ts)))
	tt=`echo "scale=8; $tn/1000000000" | bc -l`
	tp=`echo "scale=4; $tx/$tt" | bc -l`
	echo "$tx"
	echo "$tt"
} 1>&2
echo "$tp"
