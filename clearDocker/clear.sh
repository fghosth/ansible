#!/bin/bash
ansible stg-swarm -m shell -a "docker rm \$(docker ps -aq)"
ansible swarm -m shell -a "docker rm \$(docker ps -aq)"
ansible qa-swarm -m shell -a "docker rm \$(docker ps -aq)"
ansible uat-swarm -m shell -a "docker rm \$(docker ps -aq)"

ansible swarm -m shell -a "docker rmi -f \$(docker images | awk '/<none>/{print $3}')"
ansible qa-swarm -m shell -a "docker rmi -f \$(docker images | awk '/<none>/{print $3}')"
ansible stg-swarm -m shell -a "docker rmi -f \$(docker images | awk '/<none>/{print $3}')"

ansible swarm -m shell -a "docker system prune"
ansible qa-swarm -m shell -a "docker system prune"
ansible stg-swarm -m shell -a "docker system prune"

docker rmi -f $(docker images | awk '/2019/{print $3}')
