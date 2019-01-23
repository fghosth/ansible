#!/bin/bash
URL="/Users/derek/project/ansible/monitor"
server="dsp rabbitmq influxdb monitor tracking indb_gateway"
docker run --rm \
-v /Users/derek/project/go:/usr/src/myapp \
-w /usr/src/myapp/src/jvole.com/monitor \
-e GOPATH=/usr/src/myapp \
-e GOOS=linux \
-e GOARCH=amd64 \
golang go build -v


cp -f ~/project/go/src/jvole.com/monitor/monitor ${URL}/monitor_linux

ansible "${server}" -m copy -a "src=${URL}/monitor_linux dest=/data/monitor" -f 88

