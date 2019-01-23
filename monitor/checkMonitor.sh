#!/bin/bash
ansible "dspdata dsp rabbitmq influxdb indb_gateway"  -m shell -a "pgrep monitor_linux" -f 50 
