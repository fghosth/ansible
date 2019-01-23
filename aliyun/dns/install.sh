#!/bin/bash
GROUP=$1
NUM=20
if [ "$1" = "" ]; then
        echo "参数错误：请输入命令：./install.sh aldns(ansible 组名)"
        exit
fi
#安装docker
function installdns(){
ansible $GROUP -m shell -a "yum -y install bind" -f $NUM 
ansible $GROUP -m shell -a "systemctl enable named" -f $NUM 
ansible $GROUP -m copy -a "src=named.tar.gz dest=/data/" -f $NUM 
ansible $GROUP -m shell -a "tar zxf /data/named.tar.gz -C /" -f $NUM 
ansible $GROUP -m shell -a "systemctl start named" -f $NUM 
}
function main(){
installdns
}

main
