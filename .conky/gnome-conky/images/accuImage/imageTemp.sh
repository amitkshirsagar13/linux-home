#!/bin/bash
cd ~/.conky/gnome-conky/images/accuImage
cp ./day/`grep "Day Icon" toDay.txt|cut -d ":" -f 2` ./day/day.png
cp ./night/`grep "Night Icon" toDay.txt|cut -d ":" -f 2` ./night/night.png
cp ./day/`grep "Day Icon" 1.txt|cut -d ":" -f 2` ./day/1.png
cp ./day/`grep "Day Icon" 2.txt|cut -d ":" -f 2` ./day/2.png
cp ./day/`grep "Day Icon" 3.txt|cut -d ":" -f 2` ./day/3.png
cp ./day/`grep "Day Icon" 4.txt|cut -d ":" -f 2` ./day/4.png
cp ./day/`grep "Day Icon" 5.txt|cut -d ":" -f 2` ./day/5.png
cp ./moonPhases/`grep "Icon" MoonPhase.txt|cut -d ":" -f 2` ./moonPhases/now.png
