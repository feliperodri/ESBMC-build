#!/usr/bin/env bash 


setup_kubernete_cluster() {
    ansible-playbook -i hosts --ask-become-pass setup_kubernete_cluster.yml
}

setup_kubernete_cluster
