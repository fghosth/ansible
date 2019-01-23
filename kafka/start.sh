#!/bin/bash
echo "==============开启zookeeper================="
ansible kafka -m shell -a "/data/kafka/startzookeepershell.sh" -f 6
echo "==============检查zookeeper================="
ansible kafka -m shell -a "ps -ef | grep zookeeper-gc.log| grep -v grep  |awk '{print $2}'" -f 6
echo "==============等到5秒等到zookeeper集群启动================="
sleep 5 
echo "==============开启kafka================="
ansible kafka -m shell -a "/data/kafka/startkafkashell.sh" -f 6
echo "==============检查kafka================="
ansible kafka -m shell -a "ps -ef | grep kafkaServer-gc.log| grep -v grep  |awk '{print $2}'" -f 6
