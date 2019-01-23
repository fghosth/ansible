#!/bin/bash
#安装docker
ansible qaBastion -m shell -a "yum install -y git"
ansible qaBastion -m shell -a "yum install -y ansible"
ansible qaBastion -m shell -a "sed -i 's/#host_key_checking = False/host_key_checking = False/g' /etc/ansible/ansible.cfg"
ansible qaBastion -m copy -a "src=derek dest=/root/.ssh"
ansible qaBastion -m copy -a "src=derek.pub dest=/root/.ssh"
ansible qaBastion -m shell -a "chmod 600 /root/.ssh/*"
scp -i ~/.ssh/derek qa_basic_etc_hosts root@qa_b_basic:/etc/hosts
scp -i ~/.ssh/derek qa_basic_ansible_hosts root@qa_b_basic:/etc/ansible/hosts
scp -i ~/.ssh/derek qa_b_m_f_etc_hosts root@qa_b_m_f:/etc/hosts
scp -i ~/.ssh/derek qa_b_m_f_ansible_hosts root@qa_b_m_f:/etc/ansible/hosts
