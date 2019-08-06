# -*- mode: ruby -*-
# vi: set ft=ruby :

VAGRANTFILE_API_VERSION = "2"


os = ENV['OS'] || 'fedora'
if os == 'centos'
  box_name = 'centos/7'
else
  box_name = 'fedora/30-cloud-base'
end


Vagrant.configure(VAGRANTFILE_API_VERSION) do |config|
  config.vm.box = box_name

  # Tweak VirtualBox configuration for GUI applications
  config.vm.provider :virtualbox do |v|
    v.name = os
    v.memory = 2048
    v.cpus = 2
  end

  config.vm.synced_folder ".", "/vagrant"

  if os == 'centos'
    config.vm.provision "init", privileged: true, type: "shell", inline: <<-SHELL
      # sudo yum update -y
      sudo yum -y install python-dnf libselinux-python yum
      sudo yum -y install ansible
    SHELL
  else
    config.vm.provision "init", privileged: true, type: "shell", inline: <<-SHELL
      #sudo dnf update -y
      sudo dnf -y install python3-dnf libselinux-python yum
      sudo dnf -y install ansible
    SHELL
  end

  config.vm.provision "run", type: "shell", inline: <<-SHELL
    cd /vagrant
    su -c "ansible-playbook -u vagrant ./tests/test.yml -i ./tests/inventories" vagrant
  SHELL

 end
