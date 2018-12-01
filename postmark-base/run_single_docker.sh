#!/bin/bash

# Example:
# bash run_single_docker.sh read5.med runc

workload=$1
runtime=$2

docker run -it --runtime=${runtime} --rm --cap-add=NET_ADMIN \
	--device /dev/net/tun:/dev/net/tun -w /postmark \
	-v `pwd`:/postmark kollerr/postmark-experiments \
	bash -c "bash run_single_linux.sh ${workload} /data 2> /dev/null"
