# 所有主机：基本系统配置

# 关闭Selinux/firewalld
systemctl stop firewalld
systemctl disable firewalld
setenforce 0
sed -i "s/SELINUX=enforcing/SELINUX=disabled/g" /etc/selinux/config
 
# 关闭交换分区
swapoff -a
yes | cp /etc/fstab /etc/fstab_bak
cat /etc/fstab_bak |grep -v swap > /etc/fstab
 
 
# 同步时间
yum install -y ntpdate
ntpdate -u ntp.api.bz
 
# 安装内核组件
rpm -Uvh http://www.elrepo.org/elrepo-release-7.0-2.el7.elrepo.noarch.rpm ;yum --enablerepo=elrepo-kernel install kernel-ml-devel kernel-ml -y
grub2-set-default "CentOS Linux (4.18.13-1.el7.elrepo.x86_64) 7 (Core)"
 
# 检查默认内核版本高于4.18，否则请调整默认启动参数
grub2-editenv list
 
#重启以更换内核
reboot
 
# 确认内核版本
uname -a
 
# 确认内核高于4.1后，开启IPVS
cat > /etc/sysconfig/modules/ipvs.modules <<EOF
 
#!/bin/bash
ipvs_modules="ip_vs ip_vs_lc ip_vs_wlc ip_vs_rr ip_vs_wrr ip_vs_lblc ip_vs_lblcr ip_vs_dh ip_vs_sh ip_vs_fo ip_vs_nq ip_vs_sed ip_vs_ftp nf_conntrack_ipv4"
for kernel_module in \${ipvs_modules}; do
 /sbin/modinfo -F filename \${kernel_module} > /dev/null 2>&1
 if [ $? -eq 0 ]; then
 /sbin/modprobe \${kernel_module}
 fi
done
EOF
chmod 755 /etc/sysconfig/modules/ipvs.modules && bash /etc/sysconfig/modules/ipvs.modules && lsmod | grep ip_vs

# 设置网桥包经IPTables，core文件生成路径
echo """
vm.swappiness = 0
net.bridge.bridge-nf-call-ip6tables = 1
net.bridge.bridge-nf-call-iptables = 1
""" > /etc/sysctl.conf
sysctl -p


# 编辑systemctl的Docker启动文件
sed -i "13i ExecStartPost=/usr/sbin/iptables -P FORWARD ACCEPT" /usr/lib/systemd/system/docker.service
 
# 启动docker
systemctl daemon-reload
systemctl enable docker
systemctl start docker

ansible k8s -m copy -a "src=id_rsa dest=/root/.ssh"
ansible k8s -m shell -a "chmod 600 /root/.ssh/id_rsa"
