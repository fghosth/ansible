#!/bin/bash
GROUP=$1
NUM=20
if [ "$1" = "" ]; then
        echo "参数错误：请输入命令：./install.sh alzookeeper(ansible 组名)"
        exit
fi
#安装java8
function installjava(){
ansible $GROUP -m copy -a "src=jdk1.8.tar.gz dest=/opt/" -f $NUM 
ansible $GROUP -m shell -a "tar zxvf /opt/jdk1.8.tar.gz -C /opt/" -f $NUM 
}
#修改环境变量
function modifyProfile(){
ansible $GROUP -m copy -a "src=profile dest=/tmp/" -f $NUM 
ansible $GROUP -m shell -a "cat /tmp/profile >> /etc/profile" -f $NUM 
ansible $GROUP -m shell -a "cat /tmp/profile >> /etc/bashrc" -f $NUM 
ansible $GROUP -m shell -a "rm /tmp/profile" -f $NUM 
}
function main(){
installjava
modifyProfile
}

main
