#!/bin/bash
GROUP=$1
HOST="host" #每次安装前请修改服务器列表文件host
if [ "$1" = "" ]; then
        echo "参数错误：请输入命令：./install.sh aldruid(ansible 组名)"
        exit
fi
#防火墙添加端口
function setFirewalld(){
 local tcpport="1527 8000-9000 9095 3306"
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
#安装druid
function installdruid(){
ansible $GROUP -m copy -a "src=imply2.6.3.tar.gz dest=/data/" -f 10 
ansible $GROUP -m shell -a "tar -zxvf /data/imply2.6.3.tar.gz -C /data/" -f 10 
ansible $GROUP -m copy -a "src=id_rsa dest=/root/.ssh/" -f 10 
ansible $GROUP -m shell -a "chmod 600 /root/.ssh/id_rsa" -f 20
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
echo "d"
}
#修改时区,同步时间
function setUTC(){
ansible $GROUP -m shell -a "ln -s /usr/share/zoneinfo/UTC /etc/localtime" -f 10
ansible $GROUP -m shell -a "yum -y install ntp ntpdate" -f 10
ansible $GROUP -m shell -a "ntpdate cn.pool.ntp.org" -f 10
ansible $GROUP -m shell -a "hwclock --systohc" -f 10
}
main(){
setFirewalld
#installdruid
#modifyProfile
}
main
