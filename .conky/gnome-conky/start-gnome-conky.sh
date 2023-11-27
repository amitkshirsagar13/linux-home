#!/bin/bash
nohup conky -c ~/.conky/gnome-conky/gnome-rings 2>&1  </dev/null &
sleep 10
nohup conky -c ~/.conky/gnome-conky/gnome-temp 2>&1  </dev/null &
sleep 1
nohup conky -c ~/.conky/gnome-conky/gnome-cpu-processes 2>&1  </dev/null &
sleep 1
nohup conky -c ~/.conky/gnome-conky/gnome-mem-processes 2>&1  </dev/null &
sleep 5
nohup conky -c ~/.conky/gnome-conky/gnome-weather 2>&1  </dev/null &
