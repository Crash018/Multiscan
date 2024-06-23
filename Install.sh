#!/bin/bash

# Install these packages is mandatory 

sudo apt-get update

sudo apt-get install nmap

sudo apt-get install sqlmap

git clone https://github.com/commixproject/commix.git

git clone https://github.com/s0md3v/XSStrike.git 

sudo apt-get install nikto

sudo apt-get install dirb

sudo apt-get install wfuzz

sudo apt-get install sslscan

sudo apt-get install wpscan

sudo apt-get install sslyze

git clone https://github.com/spinkham/skipfish.git
cd skipfish
make
sudo make install
cd ..

sudo apt-get install wapiti

go install -v github.com/projectdiscovery/subfinder/v2/cmd/subfinder@latest

sudo apt-get install whatweb

sudo apt-get install python

sudo apt-get install python3

sudo apt-get install python3-pip

sudo apt-get install ruby

sudo apt-get install clang

sudo apt-get install figlet

sudo apt-get install golang

sudo apt-get update

sudo apt-get upgrade
