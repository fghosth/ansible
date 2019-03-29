#!/bin/bash
mkdir certs
openssl req -nodes -newkey rsa:2048 -keyout certs/dashboard.key -out certs/dashboard.csr -subj "/C=/ST=/L=/O=/OU=/CN=kubernetes-dashboard"
openssl x509 -req -sha256 -days 365 -in certs/dashboard.csr -signkey certs/dashboard.key -out certs/dashboard.crt
kubectl create secret generic kubernetes-dashboard-certs --from-file=certs -n kube-system
kubectl create -f kubernetes-dashboard.yaml
kubectl create -f admin-token.yaml

kubectl describe secret $(kubectl get secret -nkube-system |grep admin|awk '{print $1}') -n kube-system
