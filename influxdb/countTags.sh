#!/bin/bash
#o查找服务器信息
CONF="data"
readServer(){
	for line in $(cat $CONF | grep -v "^#");do   #遍历要管理的服务器
		measurement=$line
		tag="`echo $line | awk -F '_' '{print $3}'`"
		tagname=tag_${tag}
		echo "===========检查${measurement},${tagname}================="
		ansible influxdb -m shell -a "influx -username 'derek' -password 'zaqwedcxs' -database 'tracking' -execute \"SHOW TAG VALUES FROM ${measurement} WITH KEY = ${tagname}\" -format 'csv'|wc -l" -f 6
        done
}
readServer
