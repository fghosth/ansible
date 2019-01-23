#!/bin/bash
nohup /data/kafka_2.12-1.1.0/bin/kafka-server-start.sh /data/kafka_2.12-1.1.0/config/server.properties >> /data/kafka_2.12-1.1.0/kafka_start.log 2>&1 &
