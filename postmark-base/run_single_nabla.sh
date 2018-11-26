
# Example:
# bash run_single_nabla.sh nabla-ext4 tiny /var/lib/docker/postmark /var/lib/docker/postmark /var/lib/docker/postmark/log.lfs
# bash run_single_nabla.sh nabla-docker-overlay2-ext4 small / /log.lfs
# bash run_single_nabla.sh nabla-device small . /dev/sdb8
# 

name=$1
workload=$2
location=$3
logfile=$4

echo name=$1
echo workload=$2
echo location=$3
echo logfile=$4

rm -rf ${location}/tmp_data
mkdir -p ${location}/tmp_data
cp benchmark.${workload} ${location}/tmp_data/.

ts=$(date +%s%N)
time ./ukvm-bin --dir=${location}/tmp_data --log=${logfile} --net=tap100 postmark.nabla '{"cmdline":"bin/postmark.nabla /data/benchmark.'${workload}'","net":{"if":"ukvmif0","cloner":"True","type":"inet","method":"static","addr":"10.0.0.2","mask":"16"},"blk":{"source":"etfs","path":"/dev/ld0a","fstype":"blk","mountpoint":"/data"}}'
tx=`grep transactions benchmark.${workload} | awk '{print $3}'`
tn=$((($(date +%s%N) - $ts)))
tt=`echo "scale=8; $tn/1000000000" | bc -l`
tp=`echo "scale=4; $tx/$tt" | bc -l`
echo "$tx"
echo "$tt"
echo "$tp"
