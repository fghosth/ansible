#!/bin/bash
			database="tracking"
                	echo "=========创建表${database}============="
			ansible influxdb -m shell -a "influx -username 'derek' -password 'zaqwedcxs'  -execute \"create database ${database}\" " -f 6
                	echo "=========授权数据库${database}给derek ============="
			ansible influxdb -m shell -a "influx -username 'derek' -password 'zaqwedcxs'  -execute \"grant all on ${database} to derek\" " -f 6


