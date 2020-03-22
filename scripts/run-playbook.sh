#!/bin/bash

set -o xtrace

ansible-playbook -i ../ansible/inventories/dev ../ansible/playbooks/setup-all.yml
