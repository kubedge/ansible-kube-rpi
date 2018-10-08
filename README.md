# ansible-kube-rpi
Deploy Resilient Kubernetes in Raspberry Pi

Clone kubedge repo
    
    git clone https://github.com/kvenkata986/kubedge.git

Navigate to `kubedge` Folder
   
    cd kubedge

Setup wifi 

    ./setup.sh setup_wifi --wifiname="FILLMEIN" --wifipassword="FILLME"

If above output returns "Wifi is Not Setup", Please rerun the command with proper Wifi Credentials 

Install Ansible

    ./setup.sh install_ansible

Setup DHCP, NAT, Hostname, Hosts and Reboot Node

    ./setup.sh setup_node  
