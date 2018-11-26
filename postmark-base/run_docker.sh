docker run -it --rm --net=host --cap-add=NET_ADMIN --device /dev/net/tun:/dev/net/tun -v `pwd`:/postmark kollerr/postmark-experiments
