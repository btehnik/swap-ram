#!/bin/bash

SUM=0
RES=0

for DIR in `find /proc/ -maxdepth 1 -type d | egrep "^/proc/[0-9]"` ; do
        PID=`echo $DIR | cut -d / -f 3`
        PROGNAME=`grep Name $DIR/status 2>/dev/null | awk '{print $2}'`
        for SWAP in `grep Swap $DIR/smaps 2>/dev/null| awk '{ print $2 }'`
        do
                let SUM=$SUM+$SWAP/1024
        done
        echo " PID: $PID - Swap used: $SUM MB - {$PROGNAME}"
        SUM=0

done > $RES

echo "SWAP: "
egrep -v "Swap used: 0" $RES | sort -rn -k 6 | head -n 10 | cat -n

echo "RAM: "
ps aux | awk '{print $6/1024 " MB\t\t" $11}' | sort -nr  | head -n 10 | cat -n
