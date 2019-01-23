#!/bin/bash
HOST="host"
GROUP=$1
NUM=20
if [ "$1" = "" ]; then
        echo "参数错误：请输入命令：./install.sh alhadoop(ansible 组名)"
        exit
fi
#修改hosts文件
function modifyHosts(){
for line in $(cat $HOST);do
	ip=`echo $line|awk -F ':' '{print $1}'` #ip
	name=`echo $line|awk -F ':' '{print $2}'` #别名
	hline="$ip $name"
	#echo "echo \"$hline\" >> /etc/hosts"
	ansible $GROUP -m shell -a "hostnamectl set-hostname $name" -f $NUM #修改计算机名字
	ansible $GROUP -m shell -a "echo \"$hline\" >> /etc/hosts" -f $NUM
done
}
#防火墙添加端口
function setFirewalld(){
 local tcpport="9000 50010 50070 50075 50475 50020 50470 50090 8000-9000 10020 19888 60000 60010 60020 61130 2181 2888 3888 9083 10000 9864"
 for i in $tcpport
   do
   ansible $GROUP -m shell -a "firewall-cmd --permanent --add-port=$i/tcp" -f  $NUM
   ansible $GROUP -m shell -a "firewall-cmd --add-port=$i/tcp" -f $NUM 
   done
 local udpport=""
 for i in $udpport
   do
   ansible $GROUP -m shell -a "firewall-cmd --permanent --add-port=$i/udp" -f $NUM
   ansible $GROUP -m shell -a "firewall-cmd --add-port=$i/udp" -f $NUM 
   done
}
#安装hadoop3.1
function installHadoop(){
ansible $GROUP -m copy -a "src=hadoop3.1.tar.gz dest=/data/" -f $NUM 
ansible $GROUP -m shell -a "tar zxvf /data/hadoop3.1.tar.gz -C /data/" -f $NUM 
ansible $GROUP -m shell -a "/data/hadoop-3.1.0/bin/hdfs namenode -format" -f $NUM
}
#修改环境变量
function modifyProfile(){
ansible $GROUP -m copy -a "src=profile dest=/tmp/" -f $NUM 
ansible $GROUP -m shell -a "cat /tmp/profile >> /etc/profile" -f $NUM 
ansible $GROUP -m shell -a "cat /tmp/profile >> /etc/bashrc" -f $NUM 
ansible $GROUP -m shell -a "rm /tmp/profile" -f $NUM 
}

function main(){
installHadoop
#modifyProfile
}
main
