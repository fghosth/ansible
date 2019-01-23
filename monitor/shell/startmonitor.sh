#!/bin/bash
nohup /data/monitor/monitor_linux start -f /data/monitor/server.yaml >> /data/monitor/monitor.log 2>&1 &
