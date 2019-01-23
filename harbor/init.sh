#!/bin/bash
HOST="host"
GROUP="harbar"
NUM=20
#修改hosts文件
function modifyHosts(){
for line in $(cat $HOST);do
	ip=`echo $line|awk -F ':' '{print $1}'` #ip
	name=`echo $line|awk -F ':' '{print $2}'` #别名
        hline=`echo ${line//:/ }`
	#echo $name
	#echo "ssh -i ~/.ssh/derek root@$ip \"hostnamectl set-hostname $name\""
	ssh -i ~/.ssh/derek root@$name "hostnamectl set-hostname $name"	
	ansible $GROUP -m shell -a "echo \"$hline\" >> /etc/hosts" -f $NUM 
done
}
#防火墙添加端口
function setFirewalld(){
ansible aliyun -m shell -a "systemctl start firewalld" -f $NUM 
 local tcpport="443 4443 80"
 for i in $tcpport
   do
   ansible $GROUP -m shell -a "firewall-cmd --permanent --add-port=$i/tcp" -f $NUM
   ansible $GROUP -m shell -a "firewall-cmd --add-port=$i/tcp" -f $NUM 
   done
 local udpport=""
 for i in $udpport
   do
   ansible $GROUP -m shell -a "firewall-cmd --permanent --add-port=$i/udp" -f $NUM
   ansible $GROUP -m shell -a "firewall-cmd --add-port=$i/udp" -f $NUM 
   done
}
#禁用selinux
function disableSelinux(){
ansible $GROUP -m shell -a "sed -i '/SELINUX/s/enforcing/disabled/' /etc/selinux/config" -f $NUM
ansible $GROUP -m shell -a "setenforce 0" -f $NUM #临时失效
}


function main(){
setFirewalld
#modifyHosts
}
main
