#! /bin/bash

bin_dir=`dirname $0`

#sudo iptables-restore < conf/ncaa.fw
sudo sed -i "s/exit/iptables-restore < $bin_dir/../conf\/ncaa.fw\nexit/" /etc/rc.local
exit 1

# The version of ddclient in Ubuntu repositories is out of date and has a debilitating bug. A new repository must be added with a patched version of ddclient
sudo apt-add-repository ppa:nathan-renniewaldock/ppa
sudo apt-get update && sudo apt-get install ddclient
sudo cp ./conf/ddclient/ddclient.conf /etc/ddclient.conf
sudo chown root /etc/ddclient.conf # May not be necessary step
sudo ddclient

