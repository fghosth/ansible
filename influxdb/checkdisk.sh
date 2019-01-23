#!/bin/bash
ansible influxdb -m shell -a "df -h | grep /dev/sda2" -f 6
