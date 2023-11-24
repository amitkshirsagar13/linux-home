#!/bin/bash
nohup conky -c ~/.conky/gnome-conky/gnome-rings 2>&1  </dev/null &
sleep 10
# ~/.conky/gnome-conky/images/accuImage/accuWeatherCollectInformation.sh &
nohup conky -c ~/.conky/gnome-conky/gnome-temp 2>&1  </dev/null &
sleep 1
nohup conky -c ~/.conky/gnome-conky/gnome-cpu-processes 2>&1  </dev/null &
sleep 1
nohup conky -c ~/.conky/gnome-conky/gnome-mem-processes 2>&1  </dev/null &
sleep 5
nohup conky -c ~/.conky/gnome-conky/gnome-weather 2>&1  </dev/null &
sleep 30
# conky -c ~/.conky/gnome-conky/accutest
sleep 1
#conky -c ~/.conky/gnome-conky/unity_radar &
sleep 1
# conky -c ~/.conky/gnome-conky/mail &

