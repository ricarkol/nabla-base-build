# Copyright (c) 2018 Contributors as noted in the AUTHORS file
#
# Permission to use, copy, modify, and/or distribute this software
# for any purpose with or without fee is hereby granted, provided
# that the above copyright notice and this permission notice appear
# in all copies.
#
# THE SOFTWARE IS PROVIDED "AS IS" AND THE AUTHOR DISCLAIMS ALL
# WARRANTIES WITH REGARD TO THIS SOFTWARE INCLUDING ALL IMPLIED
# WARRANTIES OF MERCHANTABILITY AND FITNESS. IN NO EVENT SHALL THE
# AUTHOR BE LIABLE FOR ANY SPECIAL, DIRECT, INDIRECT, OR
# CONSEQUENTIAL DAMAGES OR ANY DAMAGES WHATSOEVER RESULTING FROM LOSS
# OF USE, DATA OR PROFITS, WHETHER IN AN ACTION OF CONTRACT,
# NEGLIGENCE OR OTHER TORTIOUS ACTION, ARISING OUT OF OR IN
# CONNECTION WITH THE USE OR PERFORMANCE OF THIS SOFTWARE.

export TOP=$(abspath ..)
all: build_docker

RUMPPKGS=$(TOP)/rumprun-packages
RUMPRUN=$(TOP)/rumprun
include ../Makefile.inc

FILES=\
benchmark.pmrc \
Dockerfile \
Makefile \

.PHONY: rumprun-packages-postmark
rumprun-packages-postmark: rumprun solo5 FORCE
	install -m 664 -D $(RUMPPKGS)/config.mk.dist $(RUMPPKGS)/config.mk
	source $(RUMPRUN)/obj/config-PATH.sh && make -C $(RUMPPKGS)/postmark all bin/postmark.seccomp
	install -m 775 -D $(RUMPPKGS)/postmark/bin/postmark.seccomp postmark.nabla

postmark.rump: postmark-1.51.c
	source ~/research/rumprun/obj/config-PATH.sh && \
		x86_64-rumprun-netbsd-gcc postmark-1.51.c -o postmark && \
		rumprun-bake hw_virtio postmark.rump postmark

run_postmark.rump: postmark.rump
	source ~/research/rumprun/obj/config-PATH.sh && rumprun qemu -i -M 512 -b `pwd`/log.lfs,/mnt postmark.rump

postmark.nabla: postmark-1.51.c
	source $(RUMPRUN)/obj/config-PATH.sh && \
		x86_64-rumprun-netbsd-gcc postmark-1.51.c -o postmark && \
		rumprun-bake solo5_ukvm_seccomp postmark.nabla postmark

postmark-split.nabla: postmark-split.c
	source $(RUMPRUN)/obj/config-PATH.sh && \
		x86_64-rumprun-netbsd-gcc postmark-split.c -o postmark-split && \
		rumprun-bake solo5_ukvm_seccomp postmark-split.nabla postmark-split

blk.nabla: blk.c
	source $(RUMPRUN)/obj/config-PATH.sh && \
		x86_64-rumprun-netbsd-gcc blk.c -o blk && \
		rumprun-bake solo5_ukvm_seccomp blk.nabla blk

rumprun-packages-postmark-1.51.clean:
	rm -f postmark-split.nabla postmark.nabla postmark postmark-split

build_docker: submodule_warning $(FILES) rumprun-packages-postmark
	sudo docker build -f Dockerfile -t nabla-postmark-base .
	sudo docker tag nabla-postmark-base nablact/nabla-postmark-base

clean:
	rm -rf postmark.nabla

distclean: clean rumprun-packages-postmark-1.51.clean solo5-clean rumprun-clean
