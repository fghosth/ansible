#!/bin/bash
HOST="host"
GROUP="uces"
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
 local tcpport="80 443 22 2376 2379 2380 6443 9099 10250 10254 30000-32767 10250-10252 10256"
 for i in $tcpport
   do
   ansible $GROUP -m shell -a "firewall-cmd --permanent --add-port=$i/tcp" -f $NUM
   ansible $GROUP -m shell -a "firewall-cmd --add-port=$i/tcp" -f $NUM 
   done
 local udpport="8472 30000-32767 4789 8472"
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

#格式化data盘并mount
function fdiskAndMount(){
  local disk="/dev/xvdb"
  ansible $GROUP -m shell -a "sh -c '/bin/echo -e \"n\np\n\n\n\nw\n\"' | fdisk $disk" 
  ansible $GROUP -m shell -a "mkfs.xfs -f $disk" 
  ansible $GROUP -m shell -a "mkdir -p /data && mount $disk /data" 
  ansible $GROUP -m shell -a "echo \"$disk /data xfs defaults 0 0\" >> /etc/fstab" 
}
#修改时区,同步时间
function setUTC(){
ansible $GROUP -m shell -a "rm -rf /etc/localtime" -f 10
ansible $GROUP -m shell -a "ln -s /usr/share/zoneinfo/UTC /etc/localtime" -f 10
ansible $GROUP -m shell -a "yum -y install ntp ntpdate" -f 10
ansible $GROUP -m shell -a "ntpdate ntp2.aliyun.com" -f 10
ansible $GROUP -m shell -a "hwclock --systohc" -f 10
}
function main(){
#disableSelinux
#setFirewalld
modifyHosts
#fdiskAndMount
#setUTC
}
main
