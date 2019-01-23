#!/bin/bash
ansible "dspdata dsp rabbitmq influxdb  indb_gateway" -m shell -a "startmonitor.sh" -f 6
