#!/bin/bash
GROUP=$1
HOST="host"
NUM=20
if [ "$1" = "" ]; then
        echo "参数错误：请输入命令：./install.sh aldocker(ansible 组名)"
        exit
fi
#安装ansible
function installansible(){
ansible $GROUP -m shell -a "yum install -y ansible" -f $NUM 
}
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
#修改ansible的host
function configAnsible(){
#	ansible $GROUP -m copy -a "src=derek dest=/root/.ssh/" -f $NUM
#        ansible $GROUP -m shell -a "chmod 600 /root/.ssh/derek" -f $NUM
#	ansible $GROUP -m copy -a "src=ansible_host dest=/etc/ansible/hosts" -f $NUM
#        ansible $GROUP -m shell -a "sed " -f $NUM
	ansible $GROUP -m shell -a "sed -i  's/#host_key_checking = False/host_key_checking = False/g'  /etc/ansible/ansible.cfg"  -f $NUM
}

function main(){
#installansible
#modifyHosts
configAnsible
}

main

