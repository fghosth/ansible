#!/bin/bash
ps -ef | grep kafkaServer-gc.log| grep -v grep  |awk '{print $2}' | xargs -I {} kill -9 {}
ps -ef | grep zookeeper-gc.log| grep -v grep  |awk '{print $2}' | xargs -I {} kill -9 {}
