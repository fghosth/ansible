#!/bin/bash
function zfs(){
sudo ros service enable zfs
sudo ros service up zfs
sudo zpool create zpool1 -m /mnt/zpool1 /dev/xvdb
sudo system-docker stop docker
sudo rm -rf /var/lib/docker/*
sudo zfs create zpool1/docker
sudo ros config set rancher.docker.storage_driver 'zfs'
sudo ros config set rancher.docker.graph /mnt/zpool1/docker
sudo system-docker start docker
}
#映射data目录
function data(){
sudo mkdir /mnt/zpool1/data
sudo chown -R rancher.rancher /mnt/zpool1/data/
sudo ln -s /mnt/zpool1/data/ /data
sudo chown -R rancher.rancher /data
}
#配置init
function init(){
sudo ros config set hostname k8s01.uuabc.derek
sudo yum install -y net-tools telnet xfsprogs
sudo yum install -y nfs-utils rpcbind
}
#dns
function setDns(){
sudo ros config set rancher.network.dns.nameservers "['172.21.0.225','172.21.0.1','172.21.0.27']"
}
#switch docker engine
function switchDocker(){
#sudo ros engine list
sudo ros engine switch docker-18.06.3-ce
}
#switch console
function switchConsole(){
#sudo ros console list
sudo ros console switch centos
}

function main(){
switchConsole
switchDocker
init
zfs
data
}

main
