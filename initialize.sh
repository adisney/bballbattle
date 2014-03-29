iptables-restore < conf/ncaa.fw

sudo echo "iptables-restore < conf/ncaa.fw" >> /etc/rc.local

# The version of ddclient in Ubuntu repositories is out of date and has a debilitating bug. A new repository must be added with a patched version of ddclient
sudo apt-add-repository ppa:nathan-renniewaldock/ppa
sudo apt-get update && sudo apt-get install ddclient
sudo cp ./conf/ddclient/ddclient.conf /etc/ddclient.conf
sudo chown root /etc/ddclient.conf # May not be necessary step
sudo ddclient

