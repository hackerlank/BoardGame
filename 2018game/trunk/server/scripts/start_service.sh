if [ ! -d "$1" ]; then
    echo $1 is not exist. abort
    exit -1
fi

dir_name=$(pwd)
dir_name=${dir_name##*/}
scr_name=${dir_name}_$1

echo dir_name $dir_name
echo scr_name $scr_name

echo 
echo kill old service
screen -S $scr_name -X quit

echo start $scr_name
cd $1

echo exec $(pwd)/run.sh

screen -dmS $scr_name sh $(pwd)/run.sh

echo waiting service startup 3
sleep 3

if [ -f cc_log.txt ]; then
    desc=$(cat cc_log.txt | grep -E "error|fail")
    if [ -n "$desc" ]; then
        if [ $(uname) = "Linux" ]; then
echo -e "\033[31m Linux $desc \033[0m"
        else
echo "\033[31m mac $desc \033[0m"
        fi
read -p "启动服务时出现错误"
exit 1
    fi
fi
