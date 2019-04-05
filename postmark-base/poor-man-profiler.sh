#!/bin/bash
nsamples=100
sleeptime=0
pid=$(pidof ukvm-bin.seccomp)

for x in $(seq 1 $nsamples)
  do
    gdb -ex "add-symbol-file /root/nabla-base-build/postmark-base/ukvm-bin.seccomp 0x0" -ex "set pagination 0" -ex "thread apply all bt" -batch -p $pid
    #gdb -ex "add-symbol-file /root/nabla-base-build/postmark-base/postmark-split.nabla 0x100000" -ex "set pagination 0" -ex "thread apply all bt" -batch -p $pid
    sleep $sleeptime
  done | \
awk '
  BEGIN { s = ""; } 
  /^Thread/ { print s; s = ""; } 
  /^\#/ { if (s != "" ) { s = s "," $4} else { s = $4 } } 
  END { print s }' | \
sort | uniq -c | sort -r -n -k 1,1
