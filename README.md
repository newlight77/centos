# centos

[![Build Status](https://travis-ci.org/newlight77/centos.svg?branch=master)](https://travis-ci.org/newlight77/centos)
[![GitHub license](https://img.shields.io/github/license/newlight77/centos?color=blue&label=license)](https://github.com/newlight77/centos/blob/master/LICENSE)

This an Ansible Playbook for CentOS Installation. It can be a great way to setup a development environment or a simple lab deployment.

## Requirements

- Ansible 2.0+.

## Quickstart

Start by cloning the repository:

```sh
git clone https://github.com/newlight77/centos /apps/centos
cd /apps/centos
```

There are three main steps for perform the setup:

1. Install Ansible

```sh
./scripts/bootstrap-ansible.sh
```

2. Configuration *(this depends on your own purpose)*

By default the scripts deploy only general setup. At this point you may optionally choose which services are deployed. Look at the `ansible/group_vars/all` and `ansible/inventory/localhost` for more details.

3. Run playbooks

```sh
sudo echo prompt password
./scripts/run-playbook.sh
```

### Contributors

```sh
vagrant up
```

or install manually a VM, then inside the vm:

```sh
ansible-playbook ansible/tests/test.yml -i ansible/tests/
```

Note: some steps may take time so it will fail as it prompts for password again while running, so run this command again:

```sh
sudo echo prompt password
```

## License

Code released under [MIT](https://github.com/hswong3i/ansible-playbook-ubuntu/blob/master/LICENSE)

## Author Information

- Kong To
    - <a href="https://twitter.com/newlight77" class="uri" class="uri">https://twitter.com/newlight77</a>
    - <a href="https://github.com/newlight77" class="uri" class="uri">https://github.com/newlight77</a>
