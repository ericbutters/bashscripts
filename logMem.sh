#!/bin/sh

STATUS=$1
PAGE=4
#PIDLIST=$(cat /tmp/pid.list)
PIDLIST=$(ls /proc | grep -v grep | grep '^[0-9]\{1,4\}$')
LASTMEM=$(free -m | grep Mem | awk {'print $4'})

while [ 1 ]; do
	MEMFREE=$(free -m | grep Mem | awk {'print $4'})
	BUFFERS=$(free | grep Mem | awk {'print $6'})
	if [ $LASTMEM -gt $MEMFREE  ]; then
		echo $(date) Free memory: $MEMFREE buffers: $BUFFERS
		for p in $PIDLIST; do
			RSS=$(cat /proc/$p/statm | awk {'print $2'})
			RSS=$(($RSS * $PAGE))
			SHR=$(cat /proc/$p/statm | awk {'print $3'})
			SHR=$(($SHR * $PAGE))
			PRIV=$(($RSS - $SHR))
			echo $(cat /proc/$p/status | grep Name) pid: $p MEM: priv: $PRIV kB rss: $RSS kB shared: $SHR kB
		done
		LASTMEM=$MEMFREE
		echo "--"
	fi
done
  

