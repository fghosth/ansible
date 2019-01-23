#!/bin/sh

##############################
#功能：检查kafka是否运行
#作者：derek
#时间：2014.1.8
###############################
echo "==============检查zookeeper================="
ansible kafka -m shell -a "netstat -nplt | grep 3888" -f 6
ansible kafka -m shell -a "netstat -nplt | grep 2181" -f 6
echo "==============检查kafka================="
ansible kafka -m shell -a "netstat -nplt | grep 9092" -f 6
