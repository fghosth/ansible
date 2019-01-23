#!/bin/bash
ansible influxdb -m shell -a "pgrep influxd | xargs -I {} ls -l /proc/{}/fd/ | wc -l" -f 6
