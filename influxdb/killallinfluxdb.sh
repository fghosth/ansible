#!/bin/bash
ansible influxdb -m shell -a "pkill influxd" -f 6
