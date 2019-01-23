#!/bin/bash
ansible influxdb -m shell -a "influx -username 'derek' -password 'zaqwedcxs' -database 'tracking' -execute \"show series\" -format 'csv'|wc -l" -f 6
