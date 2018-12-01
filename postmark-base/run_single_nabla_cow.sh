#!/bin/bash

# Example:
# bash run_single_nabla.sh read5.med pm_data log.lfs

# Location should be empty!!!

workload=$1
location=$2
logfile=$3

{
	echo workload=$1
	echo location=$2
	echo logfile=$3

	mkdir -p ${location}
	rm -rf ${location}/s[0-9]*
	rm -rf ${location}/[0-9]*

	echo "set location ${location}" > ${location}/benchmark.${workload}
	grep -v "set location" benchmark.${workload} | sed s/run/prepare/g >> ${location}/benchmark.${workload}
	./postmark-split.linux ${location}/benchmark.${workload}

	echo "set location pm_data" > ${location}/benchmark.${workload}
	grep -v "set location" benchmark.${workload} >> ${location}/benchmark.${workload}

	ts=$(date +%s%N)
	time ../solo5/ukvm/ukvm-bin.memlfs --dir=${location} --log=${logfile} --net=tap100 postmark-split.nabla '{"cmdline":"bin/postmark.nabla /pm_data/benchmark.'${workload}'","net":{"if":"ukvmif0","cloner":"True","type":"inet","method":"static","addr":"10.0.0.2","mask":"16"},"blk":{"source":"etfs","path":"/dev/ld0a","fstype":"blk","mountpoint":"/pm_data"}}'
	tx=`grep transactions benchmark.${workload} | awk '{print $3}'`
	tn=$((($(date +%s%N) - $ts)))
	tt=`echo "scale=8; $tn/1000000000" | bc -l`
	tp=`echo "scale=4; $tx/$tt" | bc -l`
	echo "$tx"
	echo "$tt"
} 1>&2
echo "$tp"
