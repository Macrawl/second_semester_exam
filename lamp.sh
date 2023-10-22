#!/bin/bash
Vagrant init ubuntu/focal64

cat << EOF > Vagrantfile
Vagrant.configure("2") do |config|

    #Master Node configuration
config.vm.define "master"  do |master|
      master.vm.hostname = "master"
      master.vm.box = "ubuntu/focal64"
      master.vm.network  "private_network", ip: "192.168.56.23"
    end
    #Slave Node Configuration
config.vm.define "slave" do |slave|
      slave.vm.hostname = "slave"
      slave.vm.box = "ubuntu/focal64"
      slave.vm.network  "private_network", ip: "192.168.56.24"
    end
    #virtualbox memory& Cpu
config.vm.provider "virtualbox" do |vb|
      vb.memory = "1024"
      vb.cpus = "2"
    end
end
EOF

vagrant up