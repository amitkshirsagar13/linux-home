#!/usr/bin/env bash
function ProgressBar {
# Process data
    let _progress=(${1}*100/${2}*100)/100
    let _done=(${_progress}*4)/10
    let _left=40-$_done
# Build progressbar string lengths
    _fill=$(printf "%${_done}s")
    _empty=$(printf "%${_left}s")

    # 1.2 Build progressbar strings and print the ProgressBar line
    # 1.2.1 Output example:                           
    # 1.2.1.1 Progress : [########################################] 100%
    printf "\rProgress : [${_fill// /#}${_empty// /-}] ${_progress}%%"

}

foo=$1
url="$1XINDEX.jpg"
# start=$2
start=1
end="$(echo "$2"|tr -d '\r')"
storage="${foo##*/}"

[[ $url =~ "idlebrain" ]] && regex='^.*\/(.*)\/.*\/' && [[ $url =~ $regex ]] && storage=${BASH_REMATCH[1]}
# [[ $url =~ "idlebrain" ]] && regex='^.*\/(.*)\/.*\/' && [[ $url =~ $regex ]] && storage=${BASH_REMATCH[1]} && echo "Trying to fetch end again" && num1regex="((([0-9])+)XINDEX)" && [[ $url =~ $num1regex ]] && end=${BASH_REMATCH[2]}

[[ $url =~ "ragalahari" ]] && regex='^.*\/(.*)\/' && [[ $url =~ $regex ]] && storage=${BASH_REMATCH[1]}
# [[ $url =~ "ragalahari" ]] && regex='^.*\/(.*)\/' && [[ $url =~ $regex ]] && storage=${BASH_REMATCH[1]} && echo "Trying to fetch end again" && num1regex="((([0-9])+)XINDEX)" && [[ $url =~ $num1regex ]] && end=${BASH_REMATCH[2]}
# start=1
# [ ! -z "$2" ] && storage="$(echo "$2/$storage"|tr -d '\r')"

[ ! -z "$3" ] && storage="$(echo "$3/$storage"|tr -d '\r')"
true $(( end++ ))
[ -d  $storage ] && echo "$storage already exists!!!" && dt=$(date '+%d%m%Y-%H%M%S') && storage="$storage$dt"
[ ! -d  $storage ] && mkdir -p $storage
echo "$storage $url $start $end"
while [ $start -lt $end ]
do
    downloadUrl="${url//XINDEX/$start}"
    wget -q $downloadUrl -P $storage >> $storage.log
    sleep 0.2
    true $(( start++ ))
    ProgressBar $start $end
done
printf "\n" 