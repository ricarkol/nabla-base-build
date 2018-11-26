docker run -it --rm --runtime=kata-runtime --cap-add=NET_ADMIN --device /dev/net/tun:/dev/net/tun -v `pwd`:/postmark kollerr/postmark-experiments
