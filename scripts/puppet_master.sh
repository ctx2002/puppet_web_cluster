#!/bin/sh
# Run on VM to bootstrap Puppet Master server

timedatectl set-timezone Pacific/Auckland

if ps aux | grep "puppetserver" | grep -v grep 2> /dev/null

then
    echo "Puppet Master is already installed. Exiting..."
else

    # Install Puppet Master
	echo "\n" >> ~/.bashrc
	echo 'export PATH=/opt/puppetlabs/bin:$PATH' >> ~/.bashrc

    wget https://apt.puppetlabs.com/puppet6-release-bionic.deb
    dpkg -i puppet6-release-bionic.deb
    apt-get update -yq
    apt-get install puppetserver -yq

	puppetserver ca setup
	apt-get install net-tools -yq
	apt-get install ntp -yq
	apt-get install -y pkg-config

    # Configure /etc/hosts file

    echo "# Host config for Puppet Master and Agent Nodes" | sudo tee --append /etc/hosts 2> /dev/null && \
    echo "192.168.50.51    puppet.example.com  puppet" | sudo tee --append /etc/hosts 2> /dev/null
	
	for var in "$@"
	do
		echo "$var" | sudo tee --append /etc/hosts 2> /dev/null
	done
	
    #echo "192.168.50.7     web4.example.com    web4" | sudo tee --append /etc/hosts 2> /dev/null

 

    # Install some initial puppet modules on Puppet Master server

    puppet module install puppetlabs-ntp
    puppet module install puppetlabs-git
    puppet module install puppetlabs-vcsrepo
    puppet module install puppet/php
    puppet module install puppet/nginx
    puppet module install puppetlabs/mysql
    apt-get install vim -yq

    #mkdir -p /etc/puppetlabs/code/environments/production/manifests

    #cp /vagrant/scripts/site.pp /etc/puppetlabs/code/environments/production/manifests/site.pp
	cp /vagrant/scripts/puppet.conf /etc/puppetlabs/puppet/puppet.conf
	cp /vagrant/scripts/puppetserver /etc/default/puppetserver
	systemctl restart puppetserver

fi