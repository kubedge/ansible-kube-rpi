# ansible-kube-rpi
Deploy Resilient Kubernetes in Raspberry Pi

Clone kubedge repo

```bash
git clone https://github.com/kvenkata986/kubedge.git
```

Navigate to `kubedge` Folder

```bash
cd kubedge
```

Setup wifi

```bash
./setup.sh setup_wifi --wifiname="FILLMEIN" --wifipassword="FILLME"
```

If above output returns "Wifi is Not Setup", Please rerun the command with proper Wifi Credentials

Install Ansible

```bash
./setup.sh install_ansible
```

Setup DHCP, NAT, Hostname, Hosts and Reboot Node

```bash
./setup.sh setup_node 
```
