#!/bin/bash
GROUP=$1
HOST="host" #每次安装前请修改服务器列表文件host
if [ "$1" = "" ]; then
        echo "参数错误：请输入命令：./install.sh alzookeeper(ansible 组名)"
        exit
fi
#防火墙添加端口
function setFirewalld(){
 local tcpport="2181 2888 3888 9866"
 for i in $tcpport
   do
   ansible $GROUP -m shell -a "firewall-cmd --permanent --add-port=$i/tcp" -f 10 
   ansible $GROUP -m shell -a "firewall-cmd --add-port=$i/tcp" -f 10 
   done
 local udpport="53"
 for i in $udpport
   do
   ansible $GROUP -m shell -a "firewall-cmd --permanent --add-port=$i/udp" -f 10
   ansible $GROUP -m shell -a "firewall-cmd --add-port=$i/udp" -f 10 
   done
}
#安装zookeeper
function installzookeeper(){
ansible $GROUP -m copy -a "src=zookeeper-3.4.12.tar.gz dest=/data/" -f 10 
ansible $GROUP -m shell -a "tar -zxvf /data/zookeeper-3.4.12.tar.gz -C /data/" -f 10 
ansible $GROUP -m copy -a "src=zoo.cfg dest=/data/zookeeper-3.4.12/conf/" -f 10
ansible $GROUP -m shell -a "mkdir /data/zookeeper-3.4.12/data" -f 10 
local i=0
for line in $(cat $HOST);do
        ip=$line #ip
	ssh -i ~/.ssh/derek root@$ip "echo \"$i\" > /data/zookeeper-3.4.12/data/myid"
	i=$[$i+1]
done
}
#修改环境变量
function modifyProfile(){
ansible $GROUP -m copy -a "src=profile dest=/tmp/" -f 10 
ansible $GROUP -m shell -a "cat /tmp/profile >> /etc/profile" -f 10 
ansible $GROUP -m shell -a "cat /tmp/profile >> /etc/bashrc" -f 10 
ansible $GROUP -m shell -a "rm /tmp/profile" -f 10 
}
#启动及监测
function startAndCheck(){
ansible $GROUP -m shell -a "/data/zookeeper-3.4.12/bin/zkServer.sh start"
ansible $GROUP -m shell -a "/data/zookeeper-3.4.12/bin/zkServer.sh status"
}
main(){
#setFirewalld
#installzookeeper
#modifyProfile
#startAndCheck
}
main
