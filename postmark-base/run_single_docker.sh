#!/bin/bash

# Example:
# bash run_single_docker.sh read5.med runc /mnt.ext4/pm_data

workload=$1
runtime=$2
location=$3

echo "set location /vol" > ${location}/benchmark.${workload}
grep -v location benchmark.${workload} >> ${location}/benchmark.${workload}

docker run -it --runtime=${runtime} --rm --cap-add=NET_ADMIN \
	--device /dev/net/tun:/dev/net/tun -w /postmark \
	-v `pwd`:/postmark \
	-v ${location}:/vol \
	kollerr/postmark-experiments \
	bash -c "bash run_single_linux.sh ${workload} /data 2> /dev/null"
