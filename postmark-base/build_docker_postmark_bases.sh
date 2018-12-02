#!/bin/bash

# Example:
# bash build_docker_postmark_bases.sh

location=pm_data

for workload in read1.small read1.med read1.large read5.small read5.med read5.large read9.small read9.med read9.large
do
	mkdir -p pm_data
	rm -rf pm_data/* # just in case

	echo "set location ${location}" > /tmp/pm.config
	grep -v "set location" benchmark.${workload} | sed s/run/prepare/g >> /tmp/pm.config
	./postmark-split.linux /tmp/pm.config

	# Dockerfile.postmark-base looks like:
	# FROM kollerr/postmark-experiments
	# RUN mkdir /pm_data
	# COPY * /pm_data/.

	cp Dockerfile.postmark-base ${location}/.
	( cd ${location} && sudo docker build -f Dockerfile.postmark-base -t kollerr/postmark-base-${workload} . )
done
