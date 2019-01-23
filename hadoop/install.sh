#!/bin/bash
HOST="host"
#修改hosts文件
function modifyHosts(){
for line in $(cat $HOST);do
	ip=`echo $line|awk -F ':' '{print $1}'` #ip
	name=`echo $line|awk -F ':' '{print $2}'` #别名
	hline="$ip $name"
	#echo "echo \"$hline\" >> /etc/hosts"
	ansible hadoop -m shell -a "hostnamectl set-hostname $name" -f 10 #修改计算机名字
	ansible hadoop -m shell -a "echo \"$hline\" >> /etc/hosts" -f 10
done
}
#防火墙添加端口
function setFirewalld(){
 local tcpport="9000 50010 50070 50075 50475 50020 50470 50090 8000-9000 10020 19888 60000 60010 60020 61130 2181 2888 3888 9083 10000 9864"
 for i in $tcpport
   do
   ansible hadoop -m shell -a "firewall-cmd --permanent --add-port=$i/tcp" -f 10 
   ansible hadoop -m shell -a "firewall-cmd --add-port=$i/tcp" -f 10 
   done
 local udpport="53"
 for i in $udpport
   do
   ansible hadoop -m shell -a "firewall-cmd --permanent --add-port=$i/udp" -f 10
   ansible hadoop -m shell -a "firewall-cmd --add-port=$i/udp" -f 10 
   done
}
#禁用selinux
function disableSelinux(){
ansible hadoop -m shell -a "sed -i '/SELINUX/s/enforcing/disabled/' /etc/selinux/config" -f 10
ansible hadoop -m shell -a "setenforce 0" -f 10 #临时失效
}
#安装hadoop3.1
function installHadoop(){
ansible hadoop -m copy -a "src=hadoop3.1.tar.gz dest=/data/" -f 10 
ansible hadoop -m shell -a "tar zxvf /data/hadoop3.1.tar.gz -C /data/" -f 10 
ansible hadoop -m shell -a "/data/hadoop-3.1.0/bin/hdfs namenode -format" -f 10
}
#修改环境变量
function modifyProfile(){
ansible hadoop -m copy -a "src=profile dest=/tmp/" -f 10 
ansible hadoop -m shell -a "cat /tmp/profile >> /etc/profile" -f 10 
ansible hadoop -m shell -a "cat /tmp/profile >> /etc/bashrc" -f 10 
ansible hadoop -m shell -a "rm /tmp/profile" -f 10 
}

