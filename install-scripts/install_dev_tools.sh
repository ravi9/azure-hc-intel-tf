#!/bin/bash
set -ex

# Install pre-reqs and development tools
yum install -y epel-release
yum groupinstall -y "Development Tools"
yum install -y git wget pssh sshpass nmap
yum install -y numactl numactl-devel libxml2-devel byacc
yum install -y pciutils lsof ethtool libnl3 libmnl tcsh
yum install -y python-devel python-setuptools python-pip
yum install -y gtk2 atk cairo tcl tk
yum install -y gcc-gfortran gcc-c++
KERNEL=$(uname -r)
yum install -y kernel-devel-${KERNEL}
yum install -y m4 libgcc.i686 glibc-devel.i686

