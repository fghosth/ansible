#!/bin/bash
ansible influxdb -m shell -a 'echo "" > /data/influxdb/influx.log' -f 6
