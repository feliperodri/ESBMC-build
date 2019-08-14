# ESBMC - Cluster Architecture

This document will explain the architecture and providing an
summary and base on the technologies used.

## Overview

### Ansible

### Docker

### Kubernetes

### Jenkins

## Instructions

### Prerequisites

SSH into the master host

Replace values in `./hosts` so it contains all hosts in the correct category:

```bash
cat hosts

[kubernete_master]
master-kubernete ansible_host=192.168.122.130

[kubernete_slave]
slave-1 ansible_host=192.168.122.184
slave-2 ansible_host=192.168.122.82
```

Configure ssh with keys from master:

```bash
ssh-keygen
ssh-copy-id 192.168.122.130
ssh-copy-id 192.168.122.184
ssh-copy-id 192.168.122.82
```

Edit `./group_vars/all` variables (`lan_range` should be the hosts network), e.g
my machines are all located in 192.168.122.* so I used 192.168.122.{1..253}

Execute `root.sh` as a priviliged user, this will install ansible:

```bash
chmod +x ./root.sh
sudo ./root.sh
```

Before proceding **ensure** that the following command results in SUCCESS for all slaves and master:

```bash
ansible -i hosts all -m ping
```
NOTE: When asked about **become**, is your **sudo** password.

### Kubernete Cluster

To set-up the cluster, run:

```bash
`./run-playbook.sh setup_kubernete_cluster.yml
```

To check, ssh into esbmc@localhost (in the master) and run `kubectl get nodes`

