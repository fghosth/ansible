#!/bin/bash
GROUP=$1
NUM=20
HOST="host"
if [ "$1" = "" ]; then
        echo "参数错误：请输入命令：./install.sh cockraochdb(ansible 组名)"
        exit
fi
#防火墙添加端口
function setFirewalld(){
 local tcpport="26257-27000"
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
#修改hosts文件
function modifyHosts(){
for line in $(cat $HOST);do
	ip=`echo $line|awk -F ':' '{print $1}'` #ip
	name=`echo $line|awk -F ':' '{print $2}'` #别名
        hline=`echo ${line//:/ }`
	#echo $name
	#echo "ssh -i ~/.ssh/derek root@$ip \"hostnamectl set-hostname $name\""
	ansible $GROUP -m shell -a "echo \"$hline\" >> /etc/hosts" -f $NUM
done
}
#安装cockroachdb
function installcockroachdb(){
ansible $GROUP -m copy -a "src=cockroach-v2.0.4.linux-amd64.tgz dest=/opt/" -f $NUM 
ansible $GROUP -m shell -a "tar zxvf /opt/cockroach-v2.0.4.linux-amd64.tgz -C /data/" -f $NUM 
ansible $GROUP -m shell -a "ln -s /data/cockroach-v2.0.4.linux-amd64/cockroach /bin/cockroach" -f $NUM 
}
function main(){
#setFirewalld
#installcockroachdb
modifyHosts
}
main
