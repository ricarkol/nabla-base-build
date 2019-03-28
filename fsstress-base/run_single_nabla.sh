#!/bin/bash

rm -rf data
mkdir -p data
../solo5/tests/test_blk/ukvm-bin --dir=data --log=log.lfs fsstress.nabla '{"cmdline":"./fsstress -l 1 -d /test -n 20000 -p 1 -c -f dwrite=0 -f dread=0 -f mknod=1 -S","blk":{"source":"etfs","path":"/dev/ld0a","fstype":"blk","mountpoint":"/test"}}'
