#!/bin/bash
ansible zookeeper -m shell -a "/data/zookeeper-3.4.12/bin/zkServer.sh status"
