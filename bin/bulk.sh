#!/usr/bin/env bash
cat bulkLoad.txt | while read line 
do
  args=($line)
  echo "${args[3]}"
  if [ -z "${args[3]}" ]
  then
      download.sh ${args[0]} ${args[1]} ${args[2]}
  else 
      download.sh ${args[0]} ${args[1]} ${args[2]} ${args[3]}
  fi
done
printf "\n" 