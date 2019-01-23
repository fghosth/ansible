#!/bin/sh
IMAGELIST[0]="k8s.gcr.io/coredns:1.2.2"
IMAGELIST[1]="k8s.gcr.io/etcd:3.2.24"
IMAGELIST[2]="k8s.gcr.io/kube-apiserver:v1.12.1"
IMAGELIST[3]="k8s.gcr.io/kube-controller-manager:v1.12.1"
IMAGELIST[4]="k8s.gcr.io/kube-proxy:v1.12.1"
IMAGELIST[5]="k8s.gcr.io/kube-scheduler:v1.12.1"
IMAGELIST[6]="k8s.gcr.io/pause:3.1"
IMAGELIST[7]="k8s.gcr.io/traefik:1.7.3"
IMAGELIST[8]="k8s.gcr.io/kubernetes-dashboard-amd64:v1.10.0"
IMAGELIST[9]="k8s.gcr.io/heapster-amd64:v1.5.4"
IMAGELIST[10]="k8s.gcr.io/heapster-influxdb-amd64:v1.3.3"
IMAGELIST[11]="k8s.gcr.io/heapster-grafana-amd64:v4.4.3"
IMAGELIST[12]="gcr.io/kubernetes-helm/tiller:v2.11.0"
IMAGELIST[13]="quay.io/calico/cni:v3.2.3"
IMAGELIST[14]="quay.io/calico/node:v3.2.3"
IMAGELIST[15]="quay.io/calico/typha:v3.2.3"
IMAGELIST[16]="quay.io/coreos/prometheus-operator:v0.20.0"
IMAGELIST[17]="quay.io/coreos/hyperkube:v1.7.6_coreos.0"
IMAGESTR=""
for image in ${IMAGELIST[@]};do
        echo "=========pulling "$image
	#docker pull $image
	if [[ "${IMAGESTR}" = "" ]] ; then
           IMAGESTR=$image
	else
           IMAGESTR=$IMAGESTR" "$image 
	fi
done
#echo  "docker save \$(${IMAGESTR}) -o k8s.tar"
docker save ${IMAGESTR} -o k8s.tar
