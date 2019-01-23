#!/bin/bash
ansible swarm -m shell -a "yum install -y git ansible"
ansible swarm -m shell -a "sed -i 's/ExecStart=\/usr\/bin\/dockerd/ExecStart=\/usr\/bin\/dockerd -H tcp:\/\/0.0.0.0:2375 -H unix:\/\/var\/run\/docker.sock/g' /usr/lib/systemd/system/docker.service"
ansible swarm -m shell -a "systemctl daemon-reload"
ansible swarm -m shell -a "systemctl restart docker"
ansible swarm -m copy -a "src=/etc/hosts dest=/etc/hosts"
ansible swarm -m copy -a "src=/etc/ansible/ansible.cfg dest=/etc/ansible/"
ansible swarm -m copy -a "src=/etc/ansible/hosts dest=/etc/ansible/"
ansible swarm -m copy -a "src=/root/.ssh/derek dest=/root/.ssh/"
ansible swarm -m shell -a "chmod 600 /root/.ssh/derek"
ansible swarm -m shell -a "docker swarm leave --force"
ansible swarm -m shell -a "mkdir -p /data/logData"
ansible swarm -m shell -a " \
docker run \
  --restart=always \
  --volume=/:/rootfs:ro \
  --volume=/var/run:/var/run:ro \
  --volume=/sys:/sys:ro \
  --volume=/var/lib/docker/:/var/lib/docker:ro \
  --volume=/dev/disk/:/dev/disk:ro \
  --publish=8081:8080 \
  --detach=true \
  --name=cadvisor \
  google/cadvisor:latest \
"
ansible swarm -m shell -a " \
docker run -d \
  --name=node_exporter \
  --restart=always \
  --net="host" \
  --pid="host" \
  -v "/:/host:ro,rslave" \
  quay.io/prometheus/node-exporter \
  --path.rootfs /host \
"
