#!/bin/bash

/usr/bin/java -jar ~/.conky/gnome-conky/images/accuImage/accuWeather.jar `pwd` > ~/.conky/gnome-conky/images/accuImage/log/accuWeatherProcessor.log
~/.conky/gnome-conky/images/accuImage/imageTemp.sh &
