#!/bin/bash

hour=$(date +'%H')
limit='18'

if [[ $hour < $limit ]]; then
 xrdb -merge $HOME/.Xresources-light
fi
