#重新启动框架程序
cd $(dirname $0)
s=$(pwd)/stop_service.sh
cd ../frame

sh $s center
sh $s redis
sh $s writer
sh $s httpd
sh $s db
sh $s plaza
sh $s login
sh $s agent
sh $s lgate
sh $s ugate
