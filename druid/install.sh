#!/bin/bash
#防火墙添加端口
function setFirewalld(){
 local tcpport="1527 8000-9000"
 for i in $tcpport
   do
   ansible druid -m shell -a "firewall-cmd --permanent --add-port=$i/tcp" -f 10 
   ansible druid -m shell -a "firewall-cmd --add-port=$i/tcp" -f 10 
   done
 local udpport="53"
 for i in $udpport
   do
   ansible druid -m shell -a "firewall-cmd --permanent --add-port=$i/udp" -f 10
   ansible druid -m shell -a "firewall-cmd --add-port=$i/udp" -f 10 
   done
}
#安装druid
function installdruid(){
ansible druid -m copy -a "src=imply2.6.tar.gz dest=/data/" -f 10 
ansible druid -m shell -a "tar -zxvf /data/imply2.6.tar.gz -C /data/" -f 10 
}
#修改环境变量
function modifyProfile(){
ansible druid -m copy -a "src=profile dest=/tmp/" -f 10 
ansible druid -m shell -a "cat /tmp/profile >> /etc/profile" -f 10 
ansible druid -m shell -a "cat /tmp/profile >> /etc/bashrc" -f 10 
ansible druid -m shell -a "rm /tmp/profile" -f 10 
}
#启动及监测
function startAndCheck(){
echo "d"
}
#修改时区,同步时间
function setUTC(){
ansible druid -m shell -a "ln -s /usr/share/zoneinfo/UTC /etc/localtime" -f 10
ansible druid -m shell -a "yum -y install ntp ntpdate" -f 10
ansible druid -m shell -a "ntpdate cn.pool.ntp.org" -f 10
ansible druid -m shell -a "hwclock --systohc" -f 10
}
main(){
setFirewalld
installdruid
modifyProfile
}
main
