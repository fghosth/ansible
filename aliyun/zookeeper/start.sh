#!/bin/bash
ansible alzookeeper -m shell -a "/data/zookeeper-3.4.12/bin/zkServer.sh start"
