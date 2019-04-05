#!/bin/bash

# Example:
# bash run_single_nabla_ext2.sh read5.med pm_data log.lfs

# Location should be empty!!!

workload=$1
location=$2
logfile=$3

echo workload=$1
echo location=$2
echo logfile=$3

rm -rf ${location} ${logfile}
mkdir -p ${location}
rm -rf ${location}/s[0-9]*
rm -rf ${location}/[0-9]*

echo "set location /pm_data" > ${location}/benchmark.${workload}
grep -v "set location" benchmark.${workload} >> ${location}/benchmark.${workload}

dd if=/dev/zero of=${logfile} count=65536 bs=8192
mkfs.ext2 ${logfile}
mount ${logfile} /mnt.ext2
cp ${location}/benchmark.${workload} /mnt.ext2
umount /mnt.ext2

#genext2fs -b 444000 -d ${location} ${logfile}

perf record -F 1000 -g -- ./ukvm-bin.seccomp --disk=${logfile} --net=tap100 postmark-split.nabla '{"cmdline":"bin/postmark.nabla /pm_data/benchmark.'${workload}'","net":{"if":"ukvmif0","cloner":"True","type":"inet","method":"static","addr":"10.0.0.2","mask":"16"},"blk":{"source":"etfs","path":"/dev/ld0a","fstype":"blk","mountpoint":"/pm_data"}}'

perf script  | ~/FlameGraph/stackcollapse-perf.pl --all --addrs | ~/FlameGraph/flamegraph.pl --color=java > kernel.svg
