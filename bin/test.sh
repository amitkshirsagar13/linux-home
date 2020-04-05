#!/usr/bin/env bash

echo "$1 $2 $3 $4"
foo=$1
url="$1XINDEX.jpg"
start=$2
end=$3
storage="${foo##*/}"
[ ! -z "$4" ] && storage="$(echo "$4/$storage"|tr -d '\r')"
echo $storage
# echo "$storage $url $start $end"
# if [ -z "$sfolder" ]
# then
#     echo "if"
#     storage="${foo##*/}"
# else 
#     echo "else"
#     storage="$sfolder"
# fi
# echo "$storage $url $start $end "