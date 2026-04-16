#!/usr/bin/env bash

if [ "$1" = "start" ]; then
    launchctl kickstart -kp gui/$(id -u)/org.nixos.sketchybar
elif [ "$1" = "check" ]; then
    launchctl print gui/$(id -u)/org.nixos.sketchybar | sed -n '1,40p'
    ps aux | rg '[s]ketchybar'
elif [ "$1" = "stop" ]; then
    launchctl bootout -kp gui/$(id -u)/org.nixos.sketchybar
else
    echo "Usage: $0 {start|check|stop}"
    exit 1
fi
