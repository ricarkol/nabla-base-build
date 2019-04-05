#!/bin/bash

# Example:
# bash run_all_docker.sh runc overlay2-ext4-ord

runtime=$1
fs=$2

for workload in read1.small read1.med read1.large read5.small read5.med read5.large read9.small read9.med read9.large
do
	for i in `seq 1 5`
	do
		echo 3 > /proc/sys/vm/drop_caches
		bash run_single_docker.sh ${workload} ${runtime} \
			2>> data/${runtime}.${fs}.${workload}.out \
			>> data/${runtime}.${fs}.${workload}.tps
	done
done
