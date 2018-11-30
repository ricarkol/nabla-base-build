#!/bin/bash

# Example:
# bash run_single_linux_cow.sh read5.med pm_data

# Location should be empty!!!

workload=$1
location=$2
keep=$3

{
	echo workload=$1
	echo location=$2
	echo keep=$3

	mkdir -p ${location}

	# if keep is not defined
	if [ -z $3 ]; then
		rm -rf ${location}/s[0-9]*
		rm -rf ${location}/[0-9]*
	fi

	echo "set location ${location}" > ${location}/benchmark.${workload}
	grep -v "set location" benchmark.${workload} | sed s/run/prepare/g >> ${location}/benchmark.${workload}
	./postmark-split.linux ${location}/benchmark.${workload}

	echo "set location ${location}" > ${location}/benchmark.${workload}
	grep -v "set location" benchmark.${workload} >> ${location}/benchmark.${workload}
	sed -i s/quit/show/g ${location}/benchmark.${workload}
	echo "quit" >> ${location}/benchmark.${workload}

	ts=$(date +%s%N)
	time ./postmark-split.linux ${location}/benchmark.${workload}
	tx=`grep transactions benchmark.${workload} | awk '{print $3}'`
	tn=$((($(date +%s%N) - $ts)))
	tt=`echo "scale=8; $tn/1000000000" | bc -l`
	tp=`echo "scale=4; $tx/$tt" | bc -l`
	echo "$tx"
	echo "$tt"
} 1>&2
echo "$tp"
