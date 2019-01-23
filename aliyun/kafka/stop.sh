#!/bin/bash
echo "==============停止kafka================="
ansible alkafka -m shell -a "/data/kafka_2.12-1.1.0/bin/stopkafka.sh" -f 6
