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

Edit `/hosts` so it contains all servers named as master and slave-$:

```bash
cat /etc/hosts

[kubernete_master]
master-kubernete ansible_host=192.168.122.130

[kubernete_slave]
slave-1 ansible_host=192.168.122.184
slave-2 ansible_host=192.168.122.82
```

Configure ssh with keys (assuming all machines have the same username as the host):

```bash
ssh-keygen
ssh-copy-id master
ssh-copy-id slave-1
ssh-copy-id slave-2
ssh-copy-id slave-3
```

Edit `env_variables` variables

Execute `root.sh` as a priviliged user:

```bash
chmod +x ./root.sh
sudo ./root.sh
```

Before proceding **ensure** that the following command results in SUCCESS for all slaves and master.

```bash
ansible all -m ping
```
