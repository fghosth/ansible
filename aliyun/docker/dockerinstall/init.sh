#!/bin/bash  
#-------------CopyRight-------------  
#   Name:centos7初始化脚本
#   Version Number:1.00  
#   Language:bash shell  
#   Date:2016-10-26  
#   Author: Derek Fan 
#   Email:fghosth@163.com
#------------Environment------------  
#   Terminal: column 80 line 24  
#   Linux 3.10.1 i686  
#   GNU Bash 3.00.15  
#-----------------------------------  

#---------1. 开关-------------------
set -x
#set -e
set -u
set -o

#-----------2. 环境变量------------
#PATH=/home/abc/bin:$PATH
#export PATH

#-----------3.source文件------------
#source lib/some_lib.sh 

#---------------4.常量--------------  
readonly ECHO="echo -ne" 
readonly ESC="\033[" 
#readonly TOOLS="strace vim wget bash-completion net-tools epel-release php70w php70w-mbstring php70w-xml php70w-pdo ntp"
readonly TOOLS="strace vim wget bash-completion net-tools epel-release ntp nfs-utils rpcbind"
readonly SSHUSER="uuabc"
readonly SSHUSER_PWD="zaq1xsw2CDE#"
readonly DATASIZE=550
readonly DATA="/data"
#添加标签 标签type：机器用途（db,load，app,route,se,cache,proxy,others）,location 机房地区(shanghai,jiaxing),room :所在机房（机房编号），cpu:cpu核心数目,mem:内存大小单位G，storage：存储介质（disk,ssd）
readonly LABEL_OPTS="--label type=DB --label location=jiaxin --label room=001 --label cpu=32 --label mem=32 --label storage=ssd"
#--------------5.变量--------------  
#color  
NULL=0 
BLACK=30 
RED=31 
GREEN=32 
ORANGE=33 
BLUE=34 
PURPLE=35 
SBLUE=36 
GREY=37 
 
#back color  
BBLACK=40 
BRED=41 
BGREEN=42 
BORANGE=43 
BBLUE=44 
BPURPLE=45 
BSBLUE=46 
BGREY=47 
 
#----------6.函数----------------
#=============安装必备工具========
function addsoftware(){
#没十分钟同步一次
echo "1.*/10 * * * * ntpdate time.nist.gov" >> /etc/crontab
 
 yum install -y epel-release
 #php7的源
yum install -y centos-release-scl-rh
 yum install -y $TOOLS 
scl enable rh-php71 bash
 curl -L -o  /usr/local/src/composer.phar "https://getcomposer.org/download/1.2.2/composer.phar"
 ln -s /usr/local/src/composer.phar /usr/local/bin/composer
 chmod +x /usr/local/src/composer.phar
#同步时间
ntpdate time.nist.gov
#sudo -H -u uuabc bash -c 'composer config -g repo.packagist composer https://packagist.phpcomposer.com' 请手动执行
}
#=======安装docker============
function installDocker(){
#yum update -y
yum install -y yum-utils device-mapper-persistent-data lvm2
yum-config-manager --add-repo https://download.docker.com/linux/centos/docker-ce.repo
#yum-config-manager --add-repo docker-ce.repo
yum install -y /data/dockerinstall/docker-ce-cli-18.09.0-3.el7.x86_64.rpm
yum install -y /data/dockerinstall/docker-ce-18.09.0-3.el7.x86_64.rpm
#yum install -y /data/dockerinstall/docker-ce-18.03.1.ce-1.el7.centos.x86_64.rpm
#yum install docker-ce
#阿里云加速
mkdir -p /etc/docker
tee /etc/docker/daemon.json <<-'EOF'
{
  "registry-mirrors": ["https://dqd3qtfe.mirror.aliyuncs.com"]
}
EOF
systemctl enable docker.service
}

#=======更改docker107G的容器限制，更换docker仓库存放位置，自动补全，仓库私钥配置
function cfgDocker(){
set +e
source /usr/share/bash-completion/bash_completion #自动补全生效
#set -e
#systemctl stop docker
rm -rf /var/lib/docker
# -d 判断 $folder 是否存在
if [ ! -d "$DATA" ]; then
  mkdir $DATA
fi
 # rm -rf $DATA/docker
  mkdir $DATA/docker
  ln -s $DATA/docker /var/lib/docker
mkdir -p /var/lib/docker/devicemapper/devicemapper
dd if=/dev/zero of=/var/lib/docker/devicemapper/devicemapper/data bs=1G count=0 seek=$DATASIZE
mkdir -p /etc/docker/certs.d/dr.gst.com
cp dr.gst.com.crt /etc/docker/certs.d/dr.gst.com/ca.crt
systemctl start docker
}

#========禁用selinux==========
function disableSelinux(){
sed -i '/SELINUX/s/enforcing/disabled/' /etc/selinux/config
setenforce 0 #临时失效
}

function commonAction(){
	systemctl enable crond.service
}
function openRemote(){
sed -i 's/ExecStart=\/usr\/bin\/dockerd/ExecStart=\/usr\/bin\/dockerd -H tcp:\/\/0.0.0.0:2375 -H unix:\/\/var\/run\/docker.sock/g' /usr/lib/systemd/system/docker.service
systemctl daemon-reload
systemctl restart docker
}

function main(){
addsoftware
installDocker
cfgDocker
commonAction
openRemote
}

#登录阿里加速服务器
#docker login --username=fghosth registry.cn-hangzhou.aliyuncs.com
main "$@"
