#!/bin/bash

# Example:
# bash run_all_lfs_cow.sh /var/lib/docker/pm_data /var/lib/docker/log.lfs ext4-ord

location=$1
log=$2
fs=$3

for workload in read1.small read1.med read1.large read5.small read5.med read5.large read9.small read9.med read9.large read10.small read10.med read10.large
do
	for i in `seq 1 5`
	do
		echo 3 > /proc/sys/vm/drop_caches
		bash run_single_lfs_cow.sh ${workload} ${location} ${log} \
			2>> data/lfs_cow.${fs}.${workload}.out \
			>> data/lfs_cow.${fs}.${workload}.tps
	done
done
