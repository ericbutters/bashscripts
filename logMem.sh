#!/bin/sh

PARAMETER=$1
PAGE=4
DIV=1024
#PIDLIST=$(cat /tmp/pid.list)
PIDLIST=$(ls /proc | grep -v grep | grep '^[0-9]\{1,5\}$')

case $PARAMETER in
"buffers")
	TRIGGER="Buffers"
	;;
*)
	TRIGGER="MemFree"
	;;
esac

LAST=$(cat /proc/meminfo | grep -w $TRIGGER: | awk {'print $2'})
if [ "$TRIGGER" != "Buffers" ]; then
	LAST=$(($LAST / $DIV))
fi

while [ 1 ]; do
#	PIDLIST=$(ls /proc | grep -v grep | grep '^[0-9]\{1,4\}$')
	CACHE=$(cat /proc/meminfo | grep -w Cached: | awk {'print $2'})
	MEMFREE=$(cat /proc/meminfo | grep -w MemFree: | awk {'print $2'})
	BUFFERS=$(cat /proc/meminfo | grep -w Buffers: | awk {'print $2'})
	MAPPED=$(cat /proc/meminfo | grep -w Mapped: | awk {'print $2'})
	SHMEM=$(cat /proc/meminfo | grep -w Shmem: | awk {'print $2'})
	SLAB=$(cat /proc/meminfo | grep -w Slab: | awk {'print $2'})
	ACTIVE=$(cat /proc/meminfo | grep -w Active: | awk {'print $2'})
	INACTIV=$(cat /proc/meminfo | grep -w Inactive: | awk {'print $2'})
	ACTIVEANON=$(cat /proc/meminfo | grep -w Active\(anon\): | awk {'print $2'})
	INACTIVEANON=$(cat /proc/meminfo | grep -w Inactive\(anon\): | awk {'print $2'})
	ACTIVEFILE=$(cat /proc/meminfo | grep -w Active\(file\): | awk {'print $2'})
	INACTIVEFILE=$(cat /proc/meminfo | grep -w Inactive\(file\): | awk {'print $2'})
	ACT=$(cat /proc/meminfo | grep -w $TRIGGER: | awk {'print $2'})
	if [ "$TRIGGER" != "Buffers" ]; then
		ACT=$(($ACT / $DIV))
	fi
	if [ $LAST -gt $ACT  ]; then
		echo $(date) Free memory: $(($MEMFREE / $DIV)) MB cache: $CACHE kB buffers: $BUFFERS kB mapped: $MAPPED kB shmem: $SHMEM kB slab: $SLAB kB
		echo ACTIVE: Active: $ACTIVE kB \($INACTIV kB\) Anon: $ACTIVEANON kB \($INACTIVEANON kB\) File: $ACTIVEFILE kB \($INACTIVEFILE kB\)
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
		LAST=$ACT
		echo "--"
	fi
	sleep 1
done
  

