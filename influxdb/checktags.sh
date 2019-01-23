#!/bin/bash
measurement=$1
tag=$2
if [ "measurement" = "" -a "tag" = "" ]; then
        echo "参数错误：请输入命令：./checktag.sh measurement_name tag_name"
        exit
fi
ansible influxdb -m shell -a "influx -username 'derek' -password 'zaqwedcxs' -database 'tracking' -execute \"SHOW TAG VALUES FROM ${measurement} WITH KEY = ${tag}\" -format 'csv'|wc -l" -f 6
