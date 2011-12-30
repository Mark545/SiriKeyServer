#!/usr/bin/env bash

echo "Welcome To This Script Made By Firebolt55439 On Github. "
echo "Downloading Required Programs... "
apt-get install build-essential dnsmasq ruby rubygems ruby-dev openssl
echo "Configuring DnsMasq... "
cp conf/dnsmasq.conf /etc/dnsmasq.conf
/etc/init.d/dnsmasq restart
echo "Generating Certificates... "
sudo ./certificate_generator.sh #Certificate Generator
