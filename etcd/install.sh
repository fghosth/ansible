#!/bin/bash
GROUP=$1
NUM=20
if [ "$1" = "" ]; then
        echo "参数错误：请输入命令：./install.sh aldocker(ansible 组名)"
        exit
fi
#安装docker
function installetcd(){
ansible $GROUP -m copy -a "src=etcd-v3.3.10-linux-amd64.tar.gz dest=/data/" -f $NUM 
ansible $GROUP -m shell -a "tar zxvf /data/etcd-v3.3.10-linux-amd64.tar.gz -C /data/" -f $NUM 
ansible $GROUP -m shell -a "mkdir -p /data/etcd-v3.3.10/conf" -f $NUM 
ansible $GROUP -m copy -a "src=conf.yml dest=/data/etcd-v3.3.10/conf/" -f $NUM 
ansible $GROUP -m shell -a "mkdir -p /data/etcd-v3.3.10/data" -f $NUM 
ansible $GROUP -m shell -a "echo \"export ETCDCTL_API=3\" >> /etc/profile " -f $NUM 
ansible $GROUP -m shell -a "echo \"export ETCDCTL_API=3\" >> /etc/bashrc " -f $NUM 
ansible $GROUP -m shell -a "source /etc/bashrc" -f $NUM 
ansible $GROUP -m shell -a "ln -s /data/etcd-v3.3.10-linux-amd64/etcd /bin/etcd" -f $NUM 
ansible $GROUP -m shell -a "ln -s /data/etcd-v3.3.10-linux-amd64/etcdctl /bin/etcdctl" -f $NUM 
ansible $GROUP -m copy -a "src=etcd.service dest=/usr/lib/systemd/system/" -f $NUM 
ansible $GROUP -m shell -a "systemctl daemon-reload && systemctl enable etcd" -f $NUM 
ansible $GROUP -m shell -a "systemctl start etcd" -f $NUM 
}
#防火墙添加端口
function setFirewalld(){
 local tcpport="2379 2380"
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
function main(){
#installetcd
setFirewalld
}

main
