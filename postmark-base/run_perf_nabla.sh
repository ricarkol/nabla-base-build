
# Example:
# bash run_perf_nabla.sh nabla-ext4 tiny /var/lib/docker/postmark /var/lib/docker/postmark /var/lib/docker/postmark/log.lfs
# bash run_perf_nabla.sh nabla-docker-overlay2-ext4 small / /log.lfs
# bash run_perf_nabla.sh nabla-device small . /dev/sdb8
# 

name=$1
workload=$2
location=$3
logfile=$4

for i in `seq 1 5`
do
	rm -rf ${location}/tmp_data
	mkdir -p ${location}/tmp_data
	cp benchmark.${workload} ${location}/tmp_data/.

	ts=$(date +%s%N)
	./ukvm-bin --dir=${location}/tmp_data --log=${logfile} --net=tap100 postmark.nabla '{"cmdline":"bin/postmark.nabla /data/benchmark.'${workload}'","net":{"if":"ukvmif0","cloner":"True","type":"inet","method":"static","addr":"10.0.0.2","mask":"16"},"blk":{"source":"etfs","path":"/dev/ld0a","fstype":"blk","mountpoint":"/data"}}' >> data/postmark.${workload}.${name}.out
	tx=`grep transactions benchmark.${workload} | awk '{print $3}'`
	tn=$((($(date +%s%N) - $ts)))
	tt=`echo "scale=8; $tn/1000000000" | bc -l`
	tp=`echo "scale=4; $tx/$tt" | bc -l`
	echo "$tp" >> data/postmark.${workload}.${name}.ms
done

printf "$name ${workload} " >> data/postmark.results
cat data/postmark.${workload}.${name}.ms | st -nh >> data/postmark.results
