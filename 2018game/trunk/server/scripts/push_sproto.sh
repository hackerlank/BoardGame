#!/bin/bash

echo "copy frame sproto to common dirs"

cd `dirname $(pwd)/$0`
cd ..

src=$(pwd)

cd ../网络
dst=$(pwd)

cp $src/doc/用户登陆流程.txt $dst/0.基础
cp $src/doc/agent.txt $dst/0.基础

cd $src/sproto

cp $src/lualib/toboolean.lua $dst/0.基础

cp $src/types/*.* $dst/0.基础
cp $src/sproto/*.* $dst/0.基础
cd $dst/0.基础
rm test.msgid.lua
rm test.sproto

echo rename *.msgid.lua to *_msgid.lua
for file in *.msgid.lua
do
    if test -f $file
    then
        mv $file ${file%.msgid.lua}_msgid.lua
    fi
done

echo copy games sproto
cd $src/games

for dir in *
do
    if test -d $dir
    then
        file=$dir/scripts/push_sproto.sh
        if test -f $file
        then
            sh $file $dst
        fi
    fi
done
