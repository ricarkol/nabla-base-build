#!/bin/bash

# Example:
# bash run_single_docker.sh read5.med

workload=$1

docker run -it --rm --net=host --cap-add=NET_ADMIN \
	--device /dev/net/tun:/dev/net/tun -w /postmark \
	-v `pwd`:/postmark kollerr/postmark-base-${workload} \
	bash -c "bash run_single_linux.sh ${workload} /pm_data keep 2> /dev/null"
