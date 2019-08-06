#!/bin/bash

set -o xtrace

ansible-playbook -i inventories/dev playbooks/setup-all.yml
