#!/bin/sh
IMAGELIST=`docker search mirrorgooglecontainers/* | grep -v NAME | awk '{printf $1":v1.12.1\n"}'`

for image in $IMAGELIST;do
        #echo $image
        export k8si=${image}
        k8simg=`echo ${k8si/mirrorgooglecontainers/k8s.gcr.io}`
        #echo $k8simg
        docker pull $image
        docker tag $image $k8simg
done
