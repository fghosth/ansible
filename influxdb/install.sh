#!/bin/bash
server=$1
filename="influxdb.tar.gz"
dirname="influxdb-1.6.1-1"
if [ "$1" = "" ]; then
        echo "参数错误：请输入命令：./install.sh influxdb(ansible 组名)"
        exit
fi
ansible ${server} -m shell -a "wget https://dl.influxdata.com/influxdb/releases/influxdb-1.6.1_linux_amd64.tar.gz  -O /data/${filename}" -f 6
ansible ${server} -m shell -a "tar zxvf /data/${filename} -C /data/" -f 6
ansible ${server} -m shell -a "mkdir /data/influxdb" -f 6
ansible ${server} -m shell -a "echo \"#!/bin/bash\" >> /data/startinflux.sh" -f 6
ansible ${server} -m shell -a "echo \"nohup /data/${dirname}/usr/bin/influxd -config /data/${dirname}/etc/influxdb/influxdb.conf >> /data/influxdb/influx.log 2>&1 &\" >> /data/startinflux.sh" -f 6
ansible ${server} -m shell -a "chmod +x /data/startinflux.sh" -f 6
ansible ${server} -m shell -a "ln -s /data/startinflux.sh /bin/startinflux.sh" -f 6
ansible ${server} -m shell -a "ln -s /data/${dirname}/usr/bin/influx /bin/influx" -f 6
ansible ${server} -m shell -a "ln -s /data/${dirname}/usr/bin/influxd /bin/influxd" -f 6
#修改数据目录
ansible ${server} -m shell -a "sed -i 's/\/var\/lib/\/data/g' /data/${dirname}/etc/influxdb/influxdb.conf" -f 6
#check
ansible ${server} -m shell -a "grep '/data' /data/${dirname}/etc/influxdb/influxdb.conf" -f 6
#启动服务
ansible ${server} -m shell -a "startinflux.sh" -f 6
#wget https://dl.influxdata.com/telegraf/releases/telegraf-1.6.1_linux_amd64.tar.gz

#add user derek
ansible ${server} -m shell -a "/data/${dirname}/usr/bin/influx -execute \"CREATE USER derek WITH PASSWORD 'zaqwedcxs' WITH ALL PRIVILEGES\"" -f 6
ansible ${server} -m shell -a "/data/${dirname}/usr/bin/influx -execute \"create database tracking\"" -f 6
ansible ${server} -m shell -a "/data/${dirname}/usr/bin/influx -execute \"create database uuabc\"" -f 6
ansible ${server} -m shell -a "/data/${dirname}/usr/bin/influx -execute \"grant all on tracking to derek\"" -f 6
ansible ${server} -m shell -a "/data/${dirname}/usr/bin/influx -execute \"grant all on uuabc to derek\"" -f 6
#check 
ansible ${server} -m shell -a "/data/${dirname}/usr/bin/influx -execute \"SHOW GRANTS FOR derek\"" -f 6

ansible ${server} -m shell -a "sed -i 's/# auth-enabled = false/auth-enabled = true/g' /data/${dirname}/etc/influxdb/influxdb.conf" -f 6
ansible ${server} -m shell -a "sed -i 's/# max-series-per-database = 1000000/max-series-per-database = 0/g' /data/${dirname}/etc/influxdb/influxdb.conf" -f 6
#ansible  ${server} -m shell -a "pkill influxd" -f 6
#ansible influxdb -m shell -a "influx -username 'derek' -password 'zaqwedcxs' -execute \"drop database tracking\"" -f 6
#ansible influxdb -m shell -a 'echo "30 3 * * * root nohup /data/backup.sh >> /data/backup.log 2>&1 &" >> /etc/crontab' -f 6
