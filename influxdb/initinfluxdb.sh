#!/bin/bash

ansible influxdb -m shell -a "sed -i 's/\/home\/ec2-user\/AdClick/\/data/g' /opt/influxdb/etc/influxdb/influxdb.conf" -f 6
#check
ansible influxdb -m shell -a "grep '/data' /opt/influxdb/etc/influxdb/influxdb.conf" -f 6
#add user derek
ansible influxdb -m shell -a "influx -execute \"CREATE USER derek WITH PASSWORD 'zaqwedcxs' WITH ALL PRIVILEGES\"" -f 6
ansible influxdb -m shell -a "influx -execute \"create database tracking\"" -f 6
ansible influxdb -m shell -a "influx -execute \"create database dsp\"" -f 6
ansible influxdb -m shell -a "influx -execute \"grant all on tracking to derek\"" -f 6
ansible influxdb -m shell -a "influx -execute \"grant all on dsp to derek\"" -f 6
#check 
ansible influxdb -m shell -a "influx -execute \"SHOW GRANTS FOR derek\"" -f 6

ansible influxdb -m shell -a "sed -i 's/#auth-enabled = true/auth-enabled = true/g' /opt/influxdb/etc/influxdb/influxdb.conf" -f 6
ansible influxdb -m shell -a "sed -i 's/# max-series-per-database = 1000000/max-series-per-database = 0/g' /opt/influxdb/etc/influxdb/influxdb.conf" -f 6
ansible influxdb -m shell -a "influx -username 'derek' -password 'zaqwedcxs' -execute \"drop database tracking\"" -f 6
ansible influxdb -m shell -a 'echo "30 3 * * * root nohup /data/backup.sh >> /data/backup.log 2>&1 &" >> /etc/crontab' -f 6
