#!/bin/bash

# Example:
# bash run_all_linux.sh /var/lib/docker/pm_data ext4

location=$1
fs=$2

for workload in read1.small read1.med read1.large read5.small read5.med read5.large read9.small read9.med read9.large read10.small read10.med read10.large
do
	for i in `seq 1 5`
	do
		echo 3 > /proc/sys/vm/drop_caches
		bash run_single_linux_cow.sh ${workload} ${location} \
			2>> data/linux_cow.${fs}.${workload}.out \
			>> data/linux_cow.${fs}.${workload}.tps
	done
done
