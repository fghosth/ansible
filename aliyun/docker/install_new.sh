#!/bin/bash
readonly DATA="/data"
readonly DATASIZE=550
#格式化data盘并mount
function fdiskAndMount(){
  local disk="/dev/vdb"
  sh -c '/bin/echo -e \"n\np\n\n\n\nw\n\"' | fdisk $disk
  mkfs.xfs -f $disk
  mkdir -p /data && mount $disk /data
  echo $disk /data xfs defaults 0 0 >> /etc/fstab
}
#修改时区,同步时间
function setUTC(){
rm -rf /etc/localtime
ln -s /usr/share/zoneinfo/UTC /etc/localtime
yum -y install ntp ntpdate
ntpdate ntp2.aliyun.com
hwclock --systohc
}
#========禁用selinux==========
function disableSelinux(){
sed -i '/SELINUX/s/enforcing/disabled/' /etc/selinux/config
setenforce 0 #临时失效
}
#install docker
function installDocker(){
yum install -y yum-utils \
  device-mapper-persistent-data \
  lvm2
yum-config-manager \
    --add-repo \
    https://download.docker.com/linux/centos/docker-ce.repo
yum install -y bash-completion net-tools docker-ce docker-ce-cli containerd.io

source /usr/share/bash-completion/bash_completion #自动补全生效
rm -rf /var/lib/docker
# -d 判断 $folder 是否存在
if [ ! -d "$DATA" ]; then
  mkdir $DATA
fi
 # rm -rf $DATA/docker
  mkdir $DATA/docker
  ln -s $DATA/docker /var/lib/docker
mkdir -p /var/lib/docker/devicemapper/devicemapper
dd if=/dev/zero of=/var/lib/docker/devicemapper/devicemapper/data bs=1G count=0 seek=$DATASIZE
systemctl enable docker

}

#install k8s
function installk8s(){
systemctl stop firewalld
systemctl disable firewalld
echo "net.ipv4.ip_forward = 1">>/etc/sysctl.conf
sysctl -p
echo 1 > /proc/sys/net/bridge/bridge-nf-call-iptables
swapoff -a
echo '[kubernetes]
name=Kubernetes
baseurl=https://mirrors.aliyun.com/kubernetes/yum/repos/kubernetes-el7-x86_64
enabled=1
gpgcheck=1
repo_gpgcheck=1
gpgkey=https://mirrors.aliyun.com/kubernetes/yum/doc/yum-key.gpg https://mirrors.aliyun.com/kubernetes/yum/doc/rpm-package-key.gpg'>/etc/yum.repos.d/kubernetes.repo
yum update -y
yum install -y kubelet kubeadm kubectl
systemctl enable kubelet.service
}

function k8sinit(){
#kubeadm init --image-repository registry.aliyuncs.com/google_containers --kubernetes-version v1.13.1 --pod-network-cidr=192.168.0.0/16 --ignore-preflight-errors=SystemVerification
kubeadm init --image-repository registry.aliyuncs.com/google_containers --kubernetes-version v1.13.1 --pod-network-cidr=192.168.0.0/16
mkdir -p $HOME/.kube
cp -i /etc/kubernetes/admin.conf $HOME/.kube/config
chown $(id -u):$(id -g) $HOME/.kube/config
#kubectl apply -f https://docs.projectcalico.org/v3.3/getting-started/kubernetes/installation/hosted/rbac-kdd.yaml
#kubectl apply -f https://docs.projectcalico.org/v3.3/getting-started/kubernetes/installation/hosted/kubernetes-datastore/calico-networking/1.7/calico.yaml
curl \
https://docs.projectcalico.org/v3.6/getting-started/kubernetes/installation/hosted/kubernetes-datastore/calico-networking/1.7/calico.yaml \
-O
kubectl apply -f calico.yaml
#kubectl taint nodes --all node-role.kubernetes.io/master-
}

function installmetrics(){
yum install -y git
git clone https://github.com/kubernetes-incubator/metrics-server
kubectl apply -y metrics-server/deploy/1.8+/
}

function joinMaster(){
USER=root
CONTROL_PLANE_IPS="k8s02 k8s03"
for host in ${CONTROL_PLANE_IPS}; do
    ssh "${USER}"@$host "mkdir -p /etc/kubernetes/pki/etcd"
    scp /etc/kubernetes/pki/apiserver-etcd-client.* "${USER}"@$host:/etc/kubernetes/pki/
    scp /etc/kubernetes/pki/ca.* "${USER}"@$host:/etc/kubernetes/pki/
    scp /etc/kubernetes/pki/sa.* "${USER}"@$host:/etc/kubernetes/pki/
    scp /etc/kubernetes/pki/front-proxy-ca.* "${USER}"@$host:/etc/kubernetes/pki/
    scp /etc/kubernetes/pki/etcd/ca.* "${USER}"@$host:/etc/kubernetes/pki/etcd/
    scp /etc/kubernetes/admin.conf "${USER}"@$host:/etc/kubernetes/
done
}


function main(){
   #fdiskAndMount
   #setUTC
#disableSelinux
#installDocker
joinMaster
}

main
