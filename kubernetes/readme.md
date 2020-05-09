# Setting up a Kubernetes Cluster

## Requirements

- One control node : this would be a VM (Vagrant)
- One master node : this would be a VM (Vagrant)
- One node1 : this would be a VM (Vagrant)
- One node2 : this would be a VM (Vagrant)
- Ansible
- Git

## Prepare

Create the 2 VMs for control and target nodes.

1. get this repo

```sh
git clone https://github.com/newlight77/centos.git

cd centos
```

2. Create the VMs

```sh
vagrant up --provision master
vagrant up --provision node1
vagrant up --provision node2
vagrant up --provision control
vagrant reload --provision master
vagrant reload --provision node1
vagrant reload --provision node2
```


3. Check if you can access to nodes :

```sh
$ ansible kube.master -m ping -i kubernetes/inventories/hosts

# outcome
kube.master | SUCCESS => {
    "ansible_facts": {
        "discovered_interpreter_python": "/usr/bin/python"
    },
    "changed": false,
    "ping": "pong"
}
```

4. Verify that `control` node can access to `master`, `node1` and `node2` without password prompt

```sh
vagrant ssh control
```

Then,

```sh
ansible -m ping master
ansible -m command -a whoami -b master

ansible -m ping node1
ansible -m command -a whoami -b node1

ansible -m ping node2
ansible -m command -a whoami -b node2
```




Now let's setup the the bootstrap playbook for the following kata

```sh
cd /vagrant

echo > /vagrant/centos/inventories/kata/hosts << EOF
[web]
target ansible_host=192.168.111.2 ansible_user=vagrant
EOF
```

4. Finally check again that `control` node can access to other nodes without password prompt

```sh
ansible -m ping master
ansible -m command -a whoami -b master

ansible -m ping node1
ansible -m command -a whoami -b node1

ansible -m ping node2
ansible -m command -a whoami -b node2
```

***Note*** : Here we can ping the target because it's defined in the inventory.

## Workshop

- [Introduction to Ansible](#Introduction)
- [Working variables](#variables)
- Exercise : inventories, group_vars, host_vars
- [Working with roles](#roles)
- Exercise :
- [Tools](#tools)
- Exercise : Find top 5 accounts sorted by balance

Duration : 3 hours