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

Edit `/etc/hosts` so it contains all servers named as master and slave-$:

```bash
cat /etc/hosts

192.168.2.1 master
192.168.2.2 slave-1
192.168.2.3 slave-2
192.168.2.3 slave-3
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
