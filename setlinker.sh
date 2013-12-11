#!/bin/bash

LD="/usr/bin/ld"
GOLD="/usr/bin/ld.gold"
DEF="/usr/bin/ld.bfd"

if [ -z "$1" ]; then
    echo "no linker passed.. exit."
    exit 1
fi

if [ -h "$LD" ]; then
    sudo rm $LD
else
    echo "no symbolic link for ld found.. exit."
    exit 2
fi

if [ "$1" == "gold" ]; then
    sudo ln -s $GOLD $LD
else
    sudo ln -s $DEF $LD
fi

exit 0
