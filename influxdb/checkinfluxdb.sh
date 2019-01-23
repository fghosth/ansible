#!/bin/bash
ansible influxdb -m shell -a "pgrep influxd" -f 6
