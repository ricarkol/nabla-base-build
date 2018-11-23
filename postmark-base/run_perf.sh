
# Example:
# bash -x run_perf.sh docker-btrfs large /

name=$1
workload=$2
location=$3

mkdir -p data

echo "set location ${location}" > /tmp/pm.location
cat /tmp/pm.location benchmark.${workload} > /tmp/pm.config

for i in `seq 1 5`
do
	ts=$(date +%s%N)
	time ./postmark.linux /tmp/pm.config >> data/postmark.${workload}.${name}.out
	tx=`grep transactions /tmp/pm.config | awk '{print $3}'`
	tn=$((($(date +%s%N) - $ts)))
	tt=`echo "scale=8; $tn/1000000000" | bc -l`
	tp=`echo "scale=4; $tx/$tt" | bc -l`
	echo "$tp" >> data/postmark.${workload}.${name}.ms
done

printf "$name ${workload} " >> data/postmark.results
cat data/postmark.${workload}.${name}.ms | st -nh >> data/postmark.results
