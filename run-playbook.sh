#!/usr/bin/env bash 

ansible-playbook -i hosts --ask-become-pass $1
