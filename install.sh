#!/usr/bin/env bash

echo "Welcome To This Script Made By Firebolt55439 On Github. "
echo "Downloading Required Programs... "
apt-get install build-essential dnsmasq ruby rubygems ruby-dev openssl
echo "Configuring Ruby and Ruby Gems..."
echo "Downloading Required Ruby Gems..."
gem install eventmachine
gem install CFPropertyList
gem install uuidtools
echo "Configuring DNS Server... "
cp conf/dnsmasq.conf /etc/dnsmasq.conf
echo "Restarting And Applying Changes To DNS..."
/etc/init.d/dnsmasq restart
echo "Generating Certificates... "
sudo ./certificate_generator.sh #Certificate Generator
