#重新启动框架程序
cd $(dirname $0)
#pkill redis-server
s=$(pwd)/start_service.sh
cd ../games/$1

sh $s hall
sh $s room
