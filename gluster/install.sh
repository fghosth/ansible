#!/bin/sh
yum install -y centos-release-gluster
yum install -y glusterfs glusterfs-server glusterfs-fuse glusterfs-rdma
systemctl enable glusterd.service
systemctl start glusterd.service
###修改hosts 必须是网卡ip否则会失败
#172.27.1.45 gluster-1
#172.27.1.16 gluster-2
gluster volume create dockerVolume  gluster-1:/data/gluster gluster-2:/data/gluster
gluster volume start dockerVolume
gluster volume info

function volume(){

# 开启 指定 volume 的配额
gluster volume quota mysql enable
# 限制 指定 volume 的配额
gluster volume quota mysql limit-usage / 30GB
# 设置 cache 大小, 默认32MB
gluster volume set mysql performance.cache-size 4GB
# 设置 io 线程, 太大会导致进程崩溃
gluster volume set mysql performance.io-thread-count 8
# 设置 网络检测时间, 默认42s
gluster volume set mysql network.ping-timeout 10
# 设置 写缓冲区的大小, 默认1M
gluster volume set mysql performance.write-behind-window-size 512MB
}
