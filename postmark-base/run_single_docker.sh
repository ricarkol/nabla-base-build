#!/bin/bash

# Example:
# bash run_single_docker.sh read5.med

workload=$1

docker run -it --rm --net=host --cap-add=NET_ADMIN \
	--device /dev/net/tun:/dev/net/tun -w /postmark \
	-v `pwd`:/postmark kollerr/postmark-experiments \
	bash -c "bash run_single_linux.sh ${workload} /data 2> /dev/null"
