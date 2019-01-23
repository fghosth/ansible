#!/bin/bash
GROUP=$1
NUM=20
if [ "$1" = "" ]; then
        echo "参数错误：请输入命令：./install.sh aldocker(ansible 组名)"
        exit
fi
#安装docker
function installdocker(){
ansible $GROUP -m copy -a "src=dockerinstall.tar.gz dest=/data/" -f $NUM 
ansible $GROUP -m shell -a "tar zxvf /data/dockerinstall.tar.gz -C /data/" -f $NUM 
ansible $GROUP -m shell -a "/data/dockerinstall/init.sh" -f $NUM 
ansible $GROUP -m shell -a "/data/dockerinstall/setCentosSafe.sh" -f $NUM 
}
function main(){
installdocker
}

main
