#!/bin/bash

if [ ! -d "$1" ]; then
    echo $1 is not exist. abort
    exit -1
fi

function kill_skynet()
{
    x=$(ps -ax | grep $(pwd)/$1 | grep skynet)

    OLD_IFS="$IFS"
    IFS=" "
    array=($x)
    IFS="$OLD_IFS"

    for each in ${array[*]}
    do
        echo kill skynet $each
        kill $each
        return
    done
}
function kill_redis()
{
    if [ -f $1/redis.pid ]; then
        x=$(cat $1/redis.pid)
        echo kill redis $x
        kill $x
    fi
}

dir_name=$(pwd)
dir_name=${dir_name##*/}
scr_name=${dir_name}_$1

echo dir_name $dir_name
echo scr_name $scr_name

echo 
echo kill old service
screen -S $scr_name -X quit

kill_skynet $1
kill_redis $1
