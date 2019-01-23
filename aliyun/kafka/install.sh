#!/bin/bash
GROUP=$1
NUM=20
if [ "$1" = "" ]; then
        echo "参数错误：请输入命令：./install.sh alkafka(ansible 组名)"
        exit
fi
#防火墙添加端口
function setFirewalld(){
 local tcpport="9092"
 for i in $tcpport
   do
   ansible $GROUP -m shell -a "firewall-cmd --permanent --add-port=$i/tcp" -f 10
   ansible $GROUP -m shell -a "firewall-cmd --add-port=$i/tcp" -f 10
   done
 local udpport=""
 for i in $udpport
   do
   ansible $GROUP -m shell -a "firewall-cmd --permanent --add-port=$i/udp" -f 10
   ansible $GROUP -m shell -a "firewall-cmd --add-port=$i/udp" -f 10
   done
}
#安装kafka
function installkafka(){
#ansible $GROUP -m copy -a "src=kafka_2.12-1.1.0.tgz dest=/data/" -f $NUM 
#ansible $GROUP -m shell -a "tar zxvf /data/kafka_2.12-1.1.0.tgz -C /data/" -f $NUM 
#ansible $GROUP -m shell -a "mkdir -p /data/kafka_2.12-1.1.0/logs" -f $NUM 
#ansible $GROUP -m copy -a "src=server.properties dest=/data/kafka_2.12-1.1.0/config/" -f 10
ansible $GROUP -m copy -a "src=shell/startkafkashell.sh dest=/data/kafka_2.12-1.1.0/bin/" -f 10
ansible $GROUP -m copy -a "src=shell/stopkafka.sh dest=/data/kafka_2.12-1.1.0/bin/" -f 10
ansible $GROUP -m shell -a "chmod +x /data/kafka_2.12-1.1.0/bin/*.sh" -f $NUM 
}
#修改环境变量
function modifyProfile(){
ansible $GROUP -m copy -a "src=profile dest=/tmp/" -f $NUM 
ansible $GROUP -m shell -a "cat /tmp/profile >> /etc/profile" -f $NUM 
ansible $GROUP -m shell -a "cat /tmp/profile >> /etc/bashrc" -f $NUM 
ansible $GROUP -m shell -a "rm /tmp/profile" -f $NUM 
}
function main(){
installkafka
#modifyProfile
#setFirewalld
}

main
