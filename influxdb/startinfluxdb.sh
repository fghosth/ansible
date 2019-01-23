#!/bin/bash
ansible influxdb -m shell -a "startinflux.sh" -f 6
