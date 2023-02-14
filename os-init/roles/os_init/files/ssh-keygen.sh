#!/usr/bin/env bash
ssh-keygen -t rsa -P "" -f /root/.ssh/id_rsa -q
ansible-playbook roles/os_init/task/os_init.yml