#!/bin/bash

function kill_skynet()
{
    x=$(ps -ax | grep $(pwd) | grep skynet)
  
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
    if [ -f redis.pid ]; then
        x=$(cat redis.pid)
        echo kill redis $x
        kill $x
    fi
}
kill_skynet
kill_redis
