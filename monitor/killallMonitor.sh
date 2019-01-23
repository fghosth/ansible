#!/bin/bash
ansible "dspdata dsp rabbitmq influxdb  indb_gateway" -m shell -a "pkill monitor_linux" -f 6
