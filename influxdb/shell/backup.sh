#!/bin/bash
dir=`date +"%Y-%m-%d"`
path=/data/backup/${dir}
mkdir -p ${path}
influxd backup -database tracking /data/backup/${dir}
