#!/usr/bin/env bash 

configure_ansible() {
    echo "Installing Ansible in the machine. Please wait..."
    yum install -y -q epel-release
    yum install -y -q ansible 
    echo "==================="   
    echo "=== DONE"
    echo "==================="
}

configure_ansible
