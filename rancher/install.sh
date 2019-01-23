#!/bin/bash
GROUP=$1
NUM=20
if [ "$1" = "" ]; then
        echo "参数错误：请输入命令：./install.sh k8s(ansible 组名)"
        exit
fi
#配置init
function init(){
ansible $GROUP -m copy -a "src=init.sh dest=/home/rancher" -f $NUM 
ansible $GROUP -m shell -a "chmod +x /home/rancher/init.sh" -f $NUM 
ansible $GROUP -m shell -a "sudo /home/rancher/init.sh" -f $NUM 
}
#映射data目录
function data(){
ansible $GROUP -m shell -a "sudo mkdir /mnt/zpool1/data"
ansible $GROUP -m shell -a "sudo chown -R rancher.rancher /mnt/zpool1/data/"
ansible $GROUP -m shell -a "sudo ln -s /mnt/zpool1/data/ /data"
ansible $GROUP -m shell -a "sudo chown -R rancher.rancher /data"
}
function main(){
init
#data
}

main
