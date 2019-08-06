#!/bin/bash

set -o xtrace

dnf -y install python3-dnf libselinux-python yum
dnf -y install ansible
