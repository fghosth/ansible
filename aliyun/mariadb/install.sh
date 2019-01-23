#!/bin/bash
GROUP=$1
NUM=20
DBA=manager
DBA_PWD=zaqwedcxs
HOST="host" #每次安装前请修改服务器列表文件host
if [ "$1" = "" ]; then
        echo "参数错误：请输入命令：./install.sh almysql(ansible 组名)"
        exit
fi
#防火墙添加端口
function setFirewalld(){
 local tcpport="3306"
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
#安装mariadb
function installmariadb(){
ansible $GROUP -m shell -a "yum -y install mariadb mariadb-server" -f  $NUM
ansible $GROUP -m shell -a "systemctl enable mariadb" -f $NUM
}
#启动及监测
function startAndCheck(){
ansible $GROUP -m shell -a "systemctl start mariadb"  -f $NUM
ansible $GROUP -m shell -a "systemctl status mariadb"  -f $NUM
ansible $GROUP -m shell -a "mysql -uroot -e 'show variables like \"%character%\";show variables like \"%collation%\";'"  -f $NUM
}
#配置mariadb
function confm(){
#/etc/my.cnf
ansible $GROUP -m shell -a "sed -i  '/^\[mysqld\]$/a\skip-character-set-client-handshake' /etc/my.cnf"  -f $NUM
ansible $GROUP -m shell -a "sed -i  '/^\[mysqld\]$/a\collation-server=utf8_unicode_ci' /etc/my.cnf"  -f $NUM
ansible $GROUP -m shell -a "sed -i  '/^\[mysqld\]$/a\character-set-server=utf8' /etc/my.cnf"  -f $NUM
ansible $GROUP -m shell -a "sed -i  '/^\[mysqld\]$/a\init_connect=\"SET NAMES utf8\"' /etc/my.cnf"  -f $NUM
ansible $GROUP -m shell -a "sed -i  '/^\[mysqld\]$/a\init_connect=\"SET collation_connection = utf8_unicode_ci\"' /etc/my.cnf"  -f $NUM

#开启bin-log
ansible $GROUP -m shell -a "mkdir -p /data/mariadb/mysql-bin"  -f $NUM
ansible $GROUP -m shell -a "sed -i  '/^\[mysqld\]$/a\log_bin_basename=/data/mariadb/mysql-bin' /etc/my.cnf"  -f $NUM
ansible $GROUP -m shell -a "sed -i  '/^\[mysqld\]$/a\log_bin_index=/data/mariadb/mysql-bin.index' /etc/my.cnf"  -f $NUM
ansible $GROUP -m shell -a "sed -i  '/^\[mysqld\]$/a\log_bin=ON' /etc/my.cnf"  -f $NUM

#/etc/my.cnf.d/client.cnf
ansible $GROUP -m shell -a "sed -i  '/^\[client\]$/a\default-character-set=utf8' /etc/my.cnf.d/client.cnf"  -f $NUM

#/etc/my.cnf.d/mysql-clients.cnf
ansible $GROUP -m shell -a "sed -i  '/^\[mysql\]$/a\default-character-set=utf8' /etc/my.cnf.d/mysql-clients.cnf"  -f $NUM
#更改数据保存路径
ansible $GROUP -m shell -a "sed -i 's/datadir=\/var\/lib\/mysql/datadir=\/data\/mariadb\/data/' /etc/my.cnf"  -f $NUM
ansible $GROUP -m shell -a "mkdir -p /data/mariadb/data"  -f $NUM
ansible $GROUP -m shell -a "sed -i 's/log-error=\/var\/log\/mariadb\/mariadb.log/log-error=\/data\/mariadb\/mariadb.log/' /etc/my.cnf"  -f $NUM

}
function addUser(){
ansible $GROUP -m shell -a "mysql -uroot -e \"grant all on *.* to ${DBA}@'%' identified by '${DBA_PWD}';\""  -f $NUM
}
main(){
#setFirewalld
#installmariadb
#modifyProfile
#confm
#startAndCheck
addUser
}
main
