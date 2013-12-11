#!/bin/sh

PIDS=`ls /proc | grep '^[0-9]\{1,4\}$'`
#echo $PIDS

for pid in $PIDS
do
     echo "NAME: " `cat /proc/$pid/stat | awk {'print $2'}`
     echo "NICE: " `cat /proc/$pid/task/*/stat | awk {'print $19'}`
     echo "--"
done   
