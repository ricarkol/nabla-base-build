name=$1
workload=$2

mkdir -p data

for i in `seq 1 2`
do
	ts=$(date +%s%N)
	time ./postmark.linux benchmark.${workload} >> data/postmark.${workload}.${name}.out
	tx=`grep transactions benchmark.${workload} | awk '{print $3}'`
	tn=$((($(date +%s%N) - $ts)))
	tt=`echo "scale=8; $tn/1000000000" | bc -l`
	tp=`echo "scale=4; $tx/$tt" | bc -l`
	echo "$tp" >> data/postmark.${workload}.${name}.ms
done

printf "$name ${workload} " >> data/postmark.results
cat data/postmark.${workload}.${name}.ms | st -nh >> data/postmark.results
