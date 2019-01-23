#!/bin/bash
echo "==============停止kafka================="
ansible kafka -m shell -a "/data/kafka/stopshell.sh" -f 6
