#!/bin/bash
GROUP=$1
NUM=20
if [ "$1" = "" ]; then
        echo "参数错误：请输入命令：./install.sh alhaproxy(ansible 组名)"
        exit
fi
#安装haproxy
function installHaproxy(){
ansible $GROUP -m shell -a "yum -y install haproxy" -f $NUM 
ansible $GROUP -m copy -a "src=haproxy.tar.gz dest=/data/" -f $NUM 
ansible $GROUP -m shell -a "tar zxvf /data/haproxy.tar.gz -C /data/" -f $NUM 
}

#修改DNS
function modifyDNS(){
ansible $GROUP -m shell -a "echo \"options timeout:2 attempts:3 rotate single-request-reopen\" > /etc/resolv.conf" -f $NUM 
ansible $GROUP -m shell -a "echo \"nameserver 172.16.58.61\" >> /etc/resolv.conf" -f $NUM 
ansible $GROUP -m shell -a "echo \"nameserver 172.16.58.68\" >> /etc/resolv.conf" -f $NUM 
}
function main(){
installHaproxy
modifyDNS
}

main
