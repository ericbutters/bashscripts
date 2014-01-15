#!/bin/sh

STATUS=$1
PAGE=4
DIV=1024
#PIDLIST=$(cat /tmp/pid.list)
PIDLIST=$(ls /proc | grep -v grep | grep '^[0-9]\{1,5\}$')
LASTMEM=$(cat /proc/meminfo | grep -w MemFree | awk {'print $2'})
LASTMEM=$(($LASTMEM / $DIV))

while [ 1 ]; do
#	PIDLIST=$(ls /proc | grep -v grep | grep '^[0-9]\{1,4\}$')
	CACHE=$(cat /proc/meminfo | grep -w Cached | awk {'print $2'})
	MEMFREE=$(cat /proc/meminfo | grep -w MemFree | awk {'print $2'})
	MEMFREE=$(($MEMFREE / $DIV))
	BUFFERS=$(cat /proc/meminfo | grep -w Buffers | awk {'print $2'})
	MAPPED=$(cat /proc/meminfo | grep -w Mapped | awk {'print $2'})
	SHMEM=$(cat /proc/meminfo | grep -w Shmem | awk {'print $2'})
	SLAB=$(cat /proc/meminfo | grep -w Slab | awk {'print $2'})
	if [ $LASTMEM -gt $MEMFREE  ]; then
		echo $(date) Free memory: $MEMFREE MB cache: $CACHE kB buffers: $BUFFERS kB mapped: $MAPPED kB shmem: $SHMEM kB slab: $SLAB kB
		for p in $PIDLIST; do
			if [ -f /proc/$p/statm ]; then
				RSS=$(cat /proc/$p/statm | awk {'print $2'})
				RSS=$(($RSS * $PAGE))
				SHR=$(cat /proc/$p/statm | awk {'print $3'})
				SHR=$(($SHR * $PAGE))
				PRIV=$(($RSS - $SHR))
				echo $(cat /proc/$p/status | grep Name) pid: $p MEM: priv: $PRIV kB rss: $RSS kB shared: $SHR kB
			fi
		done
		LASTMEM=$MEMFREE
		echo "--"
	fi
	sleep 1
done
  

