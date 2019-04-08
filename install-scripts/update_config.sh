#!/bin/bash

set -ex

# Update memory limits
cat << EOF >> /etc/security/limits.conf
*               hard    memlock         unlimited
*               soft    memlock         unlimited
*               soft    nofile          65535
*               soft    nofile          65535
EOF

# Disable GSS proxy
 yum install -y nfs-utils
sed -i 's/GSS_USE_PROXY="yes"/GSS_USE_PROXY="no"/g' /etc/sysconfig/nfs

# Enable reclaim mode
if [ -e x.txt ]; then
  cp /etc/sysctl.conf /tmp/sysctl.conf
  echo "vm.zone_reclaim_mode = 1" >> /tmp/sysctl.conf
  cp /tmp/sysctl.conf /etc/sysctl.conf
  sysctl -p
fi

# disable firewall
systemctl stop firewalld

