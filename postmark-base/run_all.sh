#!/bin/bash

FS=btrfs

bash run_all_nabla_cow.sh /var/lib/docker/pm_data /var/lib/docker/log.lfs ${FS}

bash run_all_lfs_cow.sh /var/lib/docker/pm_data /var/lib/docker/log.lfs ${FS}

bash run_all_linux_cow.sh /var/lib/docker/pm_data ${FS}

bash run_all_docker_cow.sh runc ${FS}

bash run_all_docker_cow.sh runc-docker ${FS}

exit 0

bash run_all_nabla.sh /var/lib/docker/pm_data /var/lib/docker/log.lfs ${FS}
bash run_all_linux.sh /var/lib/docker/pm_data ${FS}
bash run_all_lfs.sh /var/lib/docker/pm_data /var/lib/docker/log.lfs ${FS}

bash run_all_docker_cow.sh runsc ${FS}

bash run_all_docker_cow.sh kata-runtime ${FS}
