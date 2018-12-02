#!/bin/bash

FS=btrfs

bash run_all_linux.sh /var/lib/docker/pm_data ${FS}
bash run_all_linux_cow.sh /var/lib/docker/pm_data ${FS}

bash run_all_nabla.sh /var/lib/docker/pm_data /var/lib/docker/log.lfs ${FS}
bash run_all_nabla_cow.sh /var/lib/docker/pm_data /var/lib/docker/log.lfs ${FS}

bash run_all_docker.sh runc ${FS}
bash run_all_docker_cow.sh runc ${FS}

bash run_all_docker.sh kata-runtime ${FS}
bash run_all_docker_cow.sh kata-runtime ${FS}

bash run_all_docker.sh runsc ${FS}
bash run_all_docker_cow.sh runsc ${FS}
