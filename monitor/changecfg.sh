#!/bin/bash
ansible "dspdata dsp rabbitmq influxdb monitor tracking indb_gateway" -m shell -a "sed -i 's/ec2-user@adcsg001.hemin.im/18.184.113.236/g' /data/monitor/server.yaml" -f 50 
