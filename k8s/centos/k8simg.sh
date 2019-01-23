#!/bin/sh
IMAGELIST[0]="k8s.gcr.io/kube-apiserver:v1.13.2"
IMAGELIST[1]="k8s.gcr.io/kube-controller-manager:v1.13.2"
IMAGELIST[2]="k8s.gcr.io/kube-scheduler:v1.13.2"
IMAGELIST[3]="k8s.gcr.io/kube-proxy:v1.13.2"
IMAGELIST[4]="k8s.gcr.io/pause:3.1"
IMAGELIST[5]="k8s.gcr.io/etcd:3.2.24"
IMAGELIST[6]="k8s.gcr.io/coredns:1.2.6"
IMAGELIST[7]="k8s.gcr.io/heapster-amd64:v1.5.4"
IMAGELIST[8]="k8s.gcr.io/heapster-influxdb-amd64:v1.3.3"
IMAGELIST[9]="k8s.gcr.io/heapster-grafana-amd64:v4.4.3"
IMAGELIST[10]="k8s.gcr.io/kubernetes-dashboard-amd64:v1.10.0"
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
