#!/usr/bin/env bash

RED='\033[0;31m'
GREEN='\033[0;32m'
NC='\033[0m'

find config -name '*' | while read f ; do
    if [ $f == "config" ] ; then continue ; fi
    printf "Analyzing ====> "$f
    config_file=$(basename $f)
    DIFF=$(diff ~/$config_file $f 2> /dev/null)
    if [ $? -ne 0 ] ; then
        printf " ${RED}CHANGED${NC}\n"
    else
        printf " ${GREEN}OK${NC}\n"
    fi
done

find nixos -name '*' | while read f ; do
    if [ $f == "nixos" ] ; then continue ; fi
    printf "Analyzing ====> "$f
    config_file=$(basename $f)
    DIFF=$(diff /etc/nixos/$config_file $f 2> /dev/null)
    if [ $? -ne 0 ] ; then
        printf " ${RED}CHANGED${NC}\n"
    else
        printf " ${GREEN}OK${NC}\n"
    fi
done


