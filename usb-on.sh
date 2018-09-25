#!/bin/bash
pgrep -x dmenu && exit
mountable=$(lsblk -lp | grep "part $" | awk '{print $1, "(" $4 ")"}' | dmenu)
[[ "$mountable" = "" ]] && exit 1
chosen=$(echo $mountable | dmenu -i -p "Select the usb" | awk '{print $1}')
[[ "$chosen" = "" ]] && exit 1
udisksctl mount -b "$chosen" && exit 0 
