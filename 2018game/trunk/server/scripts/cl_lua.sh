cl_sh=$1
cl_root=$2

luac=luac5.3

if [ -d $cl_root ]
then
    echo enter $(pwd)/$cl_root
    cd $cl_root
    for file in *.lua
    do
        if [ -f $file -a "$file" != "main_config.lua" -a "$file" != "main.lua" ]
        then
            echo compile $file
            dst=$file.luac
            $luac -o $file $file
        fi
    done

    for file in *
    do
        if [ -d $file -a "$file" != "hotfix" ]
        then
            sh $cl_sh $cl_sh $file
        fi
    done
else
    echo $cl_root$ is not a dir,stop
fi
