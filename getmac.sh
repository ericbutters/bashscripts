#!/bin/bash

HOSTS=$(nmap -sP -n -oG - 192.168.178.1-126 | grep "Up" | awk '{print $2}')

for host in ${HOSTS}; do
    arp -an | grep ${host} | awk '{print $2 $4}'
  done
