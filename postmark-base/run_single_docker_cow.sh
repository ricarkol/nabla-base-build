#!/bin/bash

# Example
# bash run_single_docker_cow.sh read5.med runc

workload=$1
runtime=$2

case ${runtime} in
runc)
	docker run -it --rm --runtime=${runtime} --cap-add=NET_ADMIN \
		--device /dev/net/tun:/dev/net/tun -w /postmark \
		-v `pwd`:/postmark kollerr/postmark-base-${workload} \
		bash -c "bash run_single_linux.sh ${workload} /pm_data keep 2> /dev/null"
	;;
runsc)
	docker run -it --rm --runtime=${runtime} --cap-add=NET_ADMIN \
		--device /dev/net/tun:/dev/net/tun -w /postmark \
		-v `pwd`:/postmark kollerr/postmark-base-${workload} \
		bash -c "bash run_single_linux.sh ${workload} /pm_data keep 2> /dev/null"
	;;
kata*)
	docker run -it --rm --runtime=${runtime} --cap-add=NET_ADMIN \
		--device /dev/net/tun:/dev/net/tun -w /postmark \
		-v `pwd`:/postmark kollerr/postmark-base-${workload} \
		bash -c "bash run_single_linux.sh ${workload} /pm_data keep 2> /dev/null"
	;;
nabla*)
	docker run -it --rm --runtime=runc --privileged --cap-add=NET_ADMIN \
		--device /dev/net/tun:/dev/net/tun -w /postmark \
		-v `realpath ../solo5`:/solo5 \
		-v /dev/sdb10:/dev/sdb10 \
		-v `pwd`:/postmark kollerr/postmark-base-${workload} \
		bash -c "bash run_single_nabla.sh ${workload} /pm_data /dev/sdb10 keep 2> /dev/null"
	;;
*)
	echo "unavailable"
	exit 1
	;;
esac
