#!/bin/bash
# Sets up passwordLess ssh among a cluster in a VPN.
# Run this script on ONE of the cluster nodes. It will setup trust between the nodes.
# Outputs nodeips.txt and nodenames.txt file.

# Usage ./prep-cluster.sh [password]
# ./prep-cluster.sh Azure@123456

# Prereqs for CENTOS:
# sudo yum install -y epel-release sshpass nmap pssh


# Prereqs for UBUNTU:
# sudo apt install -y sshpass nmap pssh


AZ_PWD=$1

./setup-pwdless-ssh.sh $AZ_PWD

pssh -h ~/nodeips.txt -l $USER -i "ibv_devinfo | grep state"

echo $AZ_PWD | pssh -h ~/nodeips.txt -l $USER -I "sudo -S -- sh -c '/etc/init.d/openibd restart'"

echo $AZ_PWD | pssh -h ~/nodeips.txt -l $USER -I "sudo -S -- sh -c 'systemctl stop waagent.service'"

