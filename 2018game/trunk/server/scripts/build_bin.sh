#生成框架二进制环境
cd `dirname $(pwd)/$0`
cd ../../

m="update bin at `date '+%Y-%m-%d %H:%M:%S'`"
cc_root=$(pwd)/server
bin_root=$(pwd)/bin
cl_sh=$cc_root/scripts/cl_lua.sh

echo cc_root : $cc_root
echo bin_root : $bin_root

mkdir $bin_root
cp -r $cc_root $bin_root/

echo compile lua source file to binary
sh $cl_sh $cl_sh $bin_root

cd $bin_root
tar -zcvf server.tar.gz server
rm -r -f server

svn commit . -m "$m"

echo $m

echo all done
