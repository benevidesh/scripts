#!/bin/bash  

count=2

while [[ $count -gt 0 ]]; do
        notify-send "$count"
        sleep 1
        ((count--))
done
