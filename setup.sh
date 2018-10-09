#!/bin/bash
set -e
export ANSIBLE_HOST_KEY_CHECKING=False
wifiname=${2:---wifiname}
wifipassword=${3:---wifipassword}
echo wifiname=$wifiname
echo wifipassword=$wifipassword

setup_wifi() {
  echo "$(tput setaf 2)===============================================================$(tput setaf 9)"
  echo "$(tput setaf 2)====================== Setup Wifi =============================$(tput setaf 9)"
  echo "$(tput setaf 2)===============================================================$(tput setaf 9)"
  cat > /tmp/destfile << EOF
  auto wlan0
  iface wlan0 inet dhcp
          wpa-ssid $wifiname
          wpa-psk $wifipassword
EOF
#  sudo ifdown wlan0 && sleep 3
#  sudo ifup wlan0 && sleep 10
#  case "$(curl -s --max-time 2 -I http://security.debian.org | sed 's/^[^ ]*  *\([0-9]\).*/\1/; 1q')" in
#    [23]) echo "HTTP connectivity is up, Wifi is up Hurry";;
#    5) echo "The web proxy won't let us through";;
#    *) echo "The Wifi is Not Setup Properly, Please run ./setup setup_wifi --wifiname='WIFINAME' --wifipassword='wifipassword' with proper credentials";;
#  esac
}

usage() {
  echo "Usage:  ./setup.sh [ install_ansible, setup_node, setup_wifi ]
  exit 1
}

install_ansible() {
  ansible_version=`sudo apt-cache policy ansible | grep --color -i Candidate | awk '{print $2}'`
  echo "$(tput setaf 2)===============================================================$(tput setaf 9)"
  echo "$(tput setaf 2)==== Installing and Upgrading Ansible to $ansible_version =====$(tput setaf 9)"
  echo "$(tput setaf 2)===============================================================$(tput setaf 9)"
  sudo apt-get update
  sudo apt-get install --upgrade ansible -y
}

setup_node() {
  echo "$(tput setaf 2)===============================================================$(tput setaf 9)"
  echo "$(tput setaf 2)========================== Setup Node =========================$(tput setaf 9)"
  echo "$(tput setaf 2)===============================================================$(tput setaf 9)"
  ansible-playbook  playbooks/setup_master_node.yml
  sudo iptables -t nat -A POSTROUTING -o wlan0 -j MASQUERADE
  sudo iptables -A FORWARD -i wlan0 -o eth0 -m state --state RELATED
  sudo iptables -A FORWARD -i eth0 -o wlan0 -j ACCEPT
  sudo iptables -t nat -S
  sudo iptables -S
  sudo sh -c "iptables-save > /etc/iptables.ipv4.nat"
  echo "$(tput setaf 2)===============================================================$(tput setaf 9)"
  echo "$(tput setaf 2)====================== Rebooting Node =========================$(tput setaf 9)"
  echo "$(tput setaf 2)===============================================================$(tput setaf 9)"
  sleep 2 && sudo reboot
}

if [ $# -eq 0 ]; then
  echo "Execute <./setup.sh -h> for more options." 
else
  WIFINAME=""
  WIFIPASSWORD=""
  case $1 in
    setup_wifi) 
	while [ "$1" != "" ]; do 
	    case $1 in 
	        --wifiname ) shift 
	                     WIFINAME=$1
	        ;; 
	        --wifipassword ) shift 
	                     WIFIPASSWORD=$1
	        ;; 
                * ) usage 
	            exit 1 
	    esac 
	    shift
        done
        echo WIFINAME=$WIFINAME
        echo WIFIPASSWORD=$WIFIPASSWORD
        setup_wifi 
       # setup_wifi $WIFINAME $WIFIPASSWORD
    ;;
    install_ansible) install_ansible
    ;;
    setup_node) setup_node
    ;;
    *)
    echo "        ./$(basename $0) setup_wifi"
    echo "        ./$(basename $0) install_ansible"
    echo "        ./$(basename $0) setup_node"
    exit 1
    ;;
    esac
fi
