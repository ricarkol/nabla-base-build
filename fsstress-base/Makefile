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
Dockerfile \
Makefile \

CFLAGS=-DNO_XFS -D_LARGEFILE64_SOURCE -D_GNU_SOURCE -DDEBUG

fsstress: fsstress.c
	gcc -ggdb -o1 ${CFLAGS} -I. fsstress.c -o fsstress

fsstress.nabla: fsstress.c
	source $(RUMPRUN)/obj/config-PATH.sh && x86_64-rumprun-netbsd-gcc ${CFLAGS} -I. fsstress.c -o fsstress.rump
	source $(RUMPRUN)/obj/config-PATH.sh && rumprun-bake solo5_ukvm_seccomp fsstress.nabla fsstress.rump

build_docker: submodule_warning $(FILES)
	sudo docker build -f Dockerfile -t nabla-fsstress-base .
	sudo docker tag nabla-fsstress-base nablact/nabla-fsstress-base:memlfs

clean:
	rm -rf postmark.nabla

distclean: clean rumprun-packages-postmark-1.51.clean solo5-clean rumprun-clean
