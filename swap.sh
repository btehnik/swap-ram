#!/bin/bash

SUM=0
OVERALL=0
# get process list
for DIR in `find /proc/ -maxdepth 1 -type d | egrep "^/proc/[0-9]"` ; do
        PID=`echo $DIR | cut -d / -f 3`
        PROGNAME=`ps -p $PID -o comm --no-headers`
        for SWAP in `grep Swap $DIR/smaps 2>/dev/null| awk '{ print $2 }'`
        do
                let SUM=$SUM+$SWAP/1024
        done
        echo "PID: $PID - Swap used: $SUM MB - ($PROGNAME )"
        SUM=0
done

########################################################################
#									#
# To run the script use command:					#
# bash swap.sh | egrep -v "Swap used: 0" | sort -rn -k 6 | head -n 10	#
#									#
########################################################################
