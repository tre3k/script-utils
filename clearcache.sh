#!/usr/bin/env bash
sudo su -c "sync && echo 3 >'/proc/sys/vm/drop_caches' && swapoff -a && swapon -a  && sync && printf '\n%s\n' 'Ram-cache and Swap Cleared'" root
