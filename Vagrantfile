# -*- mode: ruby -*-
# vi: set ft=ruby :

# All Vagrant configuration is done below. The "2" in Vagrant.configure
# configures the configuration version (we support older styles for
# backwards compatibility). Please don't change it unless you know what
# you're doing.
require File.dirname(__FILE__)+"./Cluster"

Cluster.installPlugin(Vagrant, ARGV, ['vagrant-puppet-install'])

confDir = $confDir ||= File.expand_path(File.dirname(__FILE__))

loadShellScript =  confDir + "/scripts/load.sh"
webShellScript  =  confDir + "/scripts/web.sh"
puppetMaster    =  confDir + "/scripts/puppet_master.sh"

Vagrant.configure("2") do |config|

  
  # The most common configuration options are documented and commented below.
  # For a complete reference, please see the online documentation at
  # https://docs.vagrantup.com.

  # Every Vagrant development environment requires a box. You can search for
  # boxes at https://vagrantcloud.com/search.
  #config.vm.box = "base"
  config.vm.define "load1" do |load|
	load.vm.box = "ubuntu/bionic64"
	load.vm.hostname = "load-balancer-1.dev"
	load.vm.network "private_network", ip:"192.168.50.2"
	
	load.vm.provision "shell" do |s|
      s.path = loadShellScript
      s.args = ["100","192.168.50.2","192.168.50.3","MASTER","load1"]
    end
    
    load.vm.provision "shell" do |s|
      s.path = confDir + "/scripts/ssl.sh"
      s.args = ["load1"]
    end	 	
	load.vm.provider "virtualbox" do |v|
		v.memory = 1024
		v.cpus = 2
	end
  end
  #load balancer 2
  config.vm.define "load2" do |load2|
	load2.vm.box = "ubuntu/bionic64"
	load2.vm.hostname = "load-balancer-2.dev"
	load2.vm.network "private_network", ip:"192.168.50.3"
	load2.vm.provision "shell" do |s|
	s.path = loadShellScript
	s.args = ["101","192.168.50.3","192.168.50.2","BACKUP"]
	end
    
	load2.vm.provision "shell" do |s|
      s.path = confDir + "/scripts/ssl.sh"
      s.args = ["load2"]
    end
	 
     load2.vm.provider "virtualbox" do |v|
       v.memory = 1024
       v.cpus = 2
     end
  end
  #web 1
  config.vm.define "web1" do |web1|
     web1.vm.box = "ubuntu/bionic64"
     web1.vm.hostname = "web-1"
     web1.vm.network "private_network", ip:"192.168.50.4"
	 web1.vm.provision "shell" do |s|
      s.path = webShellScript
	  s.args = ["192.168.50.4", "192.168.50.2", "192.168.50.3"]
     end	  
     web1.vm.provider "virtualbox" do |v|
       v.memory = 1024
       v.cpus = 2
     end
  end
  #web 2
  config.vm.define "web2" do |web2|
     web2.vm.box = "ubuntu/bionic64"
     web2.vm.hostname = "web-2"
     web2.vm.network "private_network", ip:"192.168.50.5"  
     web2.vm.provision "shell" do |s|
      s.path = webShellScript
	  s.args = ["192.168.50.5", "192.168.50.2", "192.168.50.3"]
     end	 
     web2.vm.provider "virtualbox" do |v|
       v.memory = 1024
       v.cpus = 2
     end
  end
  
  #web 3
  config.vm.define "web3" do |web3|
     web3.vm.box = "ubuntu/bionic64"
     web3.vm.hostname = "web-3"
     web3.vm.network "private_network", ip:"192.168.50.6"   
	 web3.vm.provision "shell" do |s|
      s.path = webShellScript
	  s.args = ["192.168.50.6", "192.168.50.2", "192.168.50.3"]
     end
     web3.vm.provider "virtualbox" do |v|
       v.memory = 1024
       v.cpus = 2
     end
  end
  #web 4
  config.vm.define "web4" do |web4|
    #p web4.puppet_install.puppet_version
	#abort("ddd")
    web4.vm.box = "ubuntu/bionic64"
    web4.vm.hostname = "web-4"
    web4.vm.network "private_network", ip:"192.168.50.7"	 
    web4.vm.provision "shell" do |s|
      s.path = webShellScript
	  s.args = ["192.168.50.7", "192.168.50.2", "192.168.50.3"]
    end	 
    web4.vm.provider "virtualbox" do |v|
       v.memory = 1024
       v.cpus = 2
    end
  end
  #puppet.example.com
  config.vm.define "puppetmaster" do |puppet|
    puppet.vm.box = "ubuntu/bionic64"
    puppet.vm.hostname = "puppet.example.com"
    puppet.vm.network "private_network", ip:"192.168.50.51"
    #puppet.vm.network "forwarded_port", guest: 22, host: 2205
	puppet.ssh.port = 2205
	puppet.ssh.guest_port = 22
    puppet.vm.provision "shell" do |s|
      s.path = puppetMaster
	  s.args = ["192.168.50.7     web4.example.com    web4",
	            "192.168.50.6     web3.example.com    web3",
				"192.168.50.5     web2.example.com    web2",
				"192.168.50.4     web1.example.com    web1"]
    end	 
    puppet.vm.provider "virtualbox" do |v|
       v.memory = 1024
       v.cpus = 2
    end
  end
  
  
  

  # Disable automatic box update checking. If you disable this, then
  # boxes will only be checked for updates when the user runs
  # `vagrant box outdated`. This is not recommended.
  # config.vm.box_check_update = false

  # Create a forwarded port mapping which allows access to a specific port
  # within the machine from a port on the host machine. In the example below,
  # accessing "localhost:8080" will access port 80 on the guest machine.
  # NOTE: This will enable public access to the opened port
  # config.vm.network "forwarded_port", guest: 80, host: 8080

  # Create a forwarded port mapping which allows access to a specific port
  # within the machine from a port on the host machine and only allow access
  # via 127.0.0.1 to disable public access
  # config.vm.network "forwarded_port", guest: 80, host: 8080, host_ip: "127.0.0.1"

  # Create a private network, which allows host-only access to the machine
  # using a specific IP.
  # config.vm.network "private_network", ip: "192.168.33.10"

  # Create a public network, which generally matched to bridged network.
  # Bridged networks make the machine appear as another physical device on
  # your network.
  # config.vm.network "public_network"

  # Share an additional folder to the guest VM. The first argument is
  # the path on the host to the actual folder. The second argument is
  # the path on the guest to mount the folder. And the optional third
  # argument is a set of non-required options.
  # config.vm.synced_folder "../data", "/vagrant_data"

  # Provider-specific configuration so you can fine-tune various
  # backing providers for Vagrant. These expose provider-specific options.
  # Example for VirtualBox:
  #
  # config.vm.provider "virtualbox" do |vb|
  #   # Display the VirtualBox GUI when booting the machine
  #   vb.gui = true
  #
  #   # Customize the amount of memory on the VM:
  #   vb.memory = "1024"
  # end
  #
  # View the documentation for the provider you are using for more
  # information on available options.

  # Enable provisioning with a shell script. Additional provisioners such as
  # Puppet, Chef, Ansible, Salt, and Docker are also available. Please see the
  # documentation for more information about their specific syntax and use.
  # config.vm.provision "shell", inline: <<-SHELL
  #   apt-get update
  #   apt-get install -y apache2
  # SHELL
end
