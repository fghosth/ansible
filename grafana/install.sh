#!/bin/bash
GROUP=$1
NUM=20
if [ "$1" = "" ]; then
        echo "参数错误：请输入命令：./install.sh grafana(ansible 组名)"
        exit
fi
#防火墙添加端口
function setFirewalld(){
ansible aliyun -m shell -a "systemctl start firewalld" -f $NUM
 local tcpport="3000"
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
#安装grafana
function installgrafana(){
ansible $GROUP -m shell -a "yum install -y fontconfig freetype* urw-fonts" -f $NUM 
ansible $GROUP -m shell -a "yum install -y https://s3-us-west-2.amazonaws.com/grafana-releases/release/grafana-5.1.4-1.x86_64.rpm" -f $NUM 
ansible $GROUP -m shell -a "systemctl enable grafana-server.service" -f $NUM 
ansible $GROUP -m shell -a "systemctl start grafana-server" -f $NUM 
}
function main(){
setFirewalld
installgrafana
}

main
