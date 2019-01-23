#!/bin/bash
nohup /data/kafka/kafka_2.12-1.1.0/bin/zookeeper-server-start.sh /data/kafka/kafka_2.12-1.1.0/config/zookeeper.properties >> /data/kafka/zookeeper_start.log 2>&1 &
