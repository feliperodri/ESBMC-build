#!/usr/bin/env bash 

configure_ansible() {
    echo "Configuring and Installing Ansible in localhost. Please wait..."
    yum install -y -q epel-release
    yum install -y -q ansible 
    echo "==================="   
    echo "=== DONE"
    echo "==================="
}

configure_ansible
