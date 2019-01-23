#!/bin/bash
server=$1
URL="/Users/derek/project/ansible/monitor"
if [ "${server}" = "" ]; then
        echo "参数错误：请输入命令：./install.sh dsp(ansible的模块名称)"
        exit
fi
docker run --rm \
-v /Users/derek/project/go:/usr/src/myapp \
-w /usr/src/myapp/src/jvole.com/monitor \
-e GOPATH=/usr/src/myapp \
-e GOOS=linux \
-e GOARCH=amd64 \
golang go build -v


cp -f ~/project/go/src/jvole.com/monitor/monitor ${URL}/monitor_linux

ansible "${server}" -m shell -a "mkdir -p /data/monitor" -f 6
ansible "${server}" -m copy -a "src=${URL}/monitor_linux dest=/data/monitor" -f 8
ansible "${server}" -m copy -a "src=${URL}/server.yaml dest=/data/monitor" -f 8
ansible "${server}" -m copy -a "src=${URL}/startmonitor.sh dest=/data/monitor" -f 8
ansible "${server}" -m shell -a "ln -s /data/monitor/startmonitor.sh /bin/startmonitor.sh" -f 6
ansible "${server}" -m shell -a "chmod +x /data/monitor/monitor_linux" -f 6
ansible "${server}" -m shell -a "chmod +x /data/monitor/startmonitor.sh" -f 6
ansible "${server}" -m shell -a "startmonitor.sh" -f 6
rm monitor_linux
