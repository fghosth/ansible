#!/bin/bash
#添加host
echo "10.68.100.75 k8s-test-01" >> /etc/hosts
echo "10.68.100.76 k8s-test-02" >> /etc/hosts
#禁用防火墙
systemctl stop firewalld
systemctl disable firewalld

#禁用SELINUX
setenforce 0
sed -i '/SELINUX/s/enforcing/disabled/' /etc/selinux/config

#创建/etc/sysctl.d/k8s.conf文件
tee /etc/sysctl.d/k8s.conf <<-'EOF'
net.bridge.bridge-nf-call-ip6tables = 1
net.bridge.bridge-nf-call-iptables = 1
net.ipv4.ip_forward = 1
EOF
sysctl -p /etc/sysctl.d/k8s.conf

#禁用swap 修改 /etc/fstab 文件，注释掉 SWAP 的自动挂载
swapoff -a

echo 'vm.swappiness=0' >> /etc/sysctl.d/k8s.conf
sysctl -p /etc/sysctl.d/k8s.conf


#
cat <<EOF > /etc/yum.repos.d/kubernetes.repo
[kubernetes]
name=Kubernetes
baseurl=https://packages.cloud.google.com/yum/repos/kubernetes-el7-x86_64
enabled=1
gpgcheck=1
repo_gpgcheck=1
gpgkey=https://packages.cloud.google.com/yum/doc/yum-key.gpg
        https://packages.cloud.google.com/yum/doc/rpm-package-key.gpg
EOF

#ulimit设置
cat <<EOF > /etc/security/limits.d/90-nproc.conf
*          soft    nproc     50000
*          hard    nproc     60000
*          soft    nofile    1024000
*          hard    nofile    1024000
root       soft    nproc     unlimited
EOF


#需代理
yum makecache fast
yum install -y kubelet kubeadm kubectl
systemctl enable kubelet.service
kubeadm init --kubernetes-version=v1.13.2 \
--pod-network-cidr=10.244.0.0/16 \ 
--ignore-preflight-errors=SystemVerification \
--apiserver-advertise-address=10.68.100.75

#kubeadm config images list 查看需要的images 
function dealServerImages(){
docker pull mirrorgooglecontainers/kube-apiserver-amd64:v1.13.2
docker pull mirrorgooglecontainers/kube-controller-manager-amd64:v1.13.2
docker pull mirrorgooglecontainers/kube-scheduler-amd64:v1.13.2
docker pull mirrorgooglecontainers/kube-proxy-amd64:v1.13.2
docker pull mirrorgooglecontainers/pause-amd64:3.1
docker pull mirrorgooglecontainers/etcd-amd64:3.2.24
docker pull carlziess/coredns-1.2.6

docker tag mirrorgooglecontainers/kube-apiserver-amd64:v1.13.2 k8s.gcr.io/kube-apiserver:v1.13.2
docker tag mirrorgooglecontainers/kube-controller-manager-amd64:v1.13.2 k8s.gcr.io/kube-controller-manager:v1.13.2
docker tag mirrorgooglecontainers/kube-scheduler-amd64:v1.13.2 k8s.gcr.io/kube-scheduler:v1.13.2
docker tag mirrorgooglecontainers/kube-proxy-amd64:v1.13.2 k8s.gcr.io/kube-proxy:v1.13.2
docker tag mirrorgooglecontainers/pause-amd64:3.1 k8s.gcr.io/pause:3.1
docker tag mirrorgooglecontainers/etcd-amd64:3.2.24 k8s.gcr.io/etcd:3.2.24
docker tag carlziess/coredns-1.2.6 k8s.gcr.io/coredns:1.2.6

}


function deleteImages(){
docker rmi mirrorgooglecontainers/kube-apiserver-amd64:v1.13.2
docker rmi mirrorgooglecontainers/kube-scheduler:v1.13.2
docker rmi mirrorgooglecontainers/kube-apiserver:v1.13.2
docker rmi mirrorgooglecontainers/kube-controller-manager:v1.13.2
docker rmi mirrorgooglecontainers/etcd:3.2.24
docker rmi mirrorgooglecontainers/pause:3.1
docker rmi carlziess/coredns-1.2.6
}
#设置kubectl访问配置
mkdir -p $HOME/.kube
sudo cp -i /etc/kubernetes/admin.conf $HOME/.kube/config
sudo chown $(id -u):$(id -g) $HOME/.kube/config

#安装flannel network
mkdir -p ~/k8s/
cd ~/k8s
wget https://raw.githubusercontent.com/coreos/flannel/master/Documentation/kube-flannel.yml
kubectl create -f kube-flannel.yml
# check: kubectl get ds -l app=flannel -n kube-system
#使用kubectl get pod -n kube-system -o wide确保所有的Pod都处于Running状态。
#使用kubeadm初始化的集群，出于安全考虑Pod不会被调度到Master Node上，也就是说Master Node不参与工作负载
#kubectl describe node k8s-test-02 | grep Taint 
#掉这个污点使node1参与工作负载：
kubectl taint nodes k8s-test-02 node-role.kubernetes.io/master-node "k8s-test-02" untaintednode/k8s-test-02 untainted
kubeadm join 172.21.0.138:6443 --token dh999a.dwfq9d5yjrcxoadn --discovery-token-ca-cert-hash sha256:8adafaecc9a08916f32dc6157915cfb4e65fbdd7985b8b0a868d5a1cdb2ac0bc
