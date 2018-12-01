#!/bin/bash

# Example:
# bash run_all_nabla.sh /var/lib/docker/pm_data /var/lib/docker/log.lfs ext4-ord

location=$1
log=$2
fs=$3

for workload in read1.small read1.med read1.large read5.small read5.med read5.large read9.small read9.med read9.large
do
	for i in `seq 1 5`
	do
		bash run_single_nabla.sh ${workload} ${location} ${log} \
			2>> data/nabla.${fs}.${workload}.out \
			>> data/nabla.${fs}.${workload}.tps
	done
done
