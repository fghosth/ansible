#!/bin/bash
echo "==============开启kafka================="
ansible alkafka -m shell -a "/data/kafka_2.12-1.1.0/bin/startkafkashell.sh" -f 6
echo "==============检查kafka================="
ansible alkafka -m shell -a "ps -ef | grep kafkaServer-gc.log| grep -v grep  |awk '{print $2}'" -f 6
