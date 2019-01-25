#!/bin/bash
yum install -y go
echo "export GOPATH=/data/go" >> /etc/profile
echo "export GO_BIN_HOME=$GOPATH/bin" >> /etc/profile
echo "export PATH=$PATH:$GO_BIN_HOME" >> /etc/profile
git config --global http.proxy http://172.16.115.132:3128
git config --global https.proxy http://172.16.115.132:3128
mkdir -p /data/go/src/uuabc.com
git config --global credential.helper store
cd /data/go/src/uuabc.com && git clone https://gitlab.51uuabc.com/share/sso.git 
cd /data && git clone https://gitlab.51uuabc.com/derek/uudeploy.git

