#!/bin/bash
# Install communication runtimes and MPI libraries

set -x

source /mnt/shared/setenv

INSTALL_PREFIX=/opt

mkdir -p /tmp/mpi
cd /tmp/mpi

# Intel MPI 2019 (update 4)
yum-config-manager --add-repo https://yum.repos.intel.com/mpi/setup/intel-mpi.repo
rpm --import https://yum.repos.intel.com/intel-gpg-keys/GPG-PUB-KEY-INTEL-SW-PRODUCTS-2019.PUB
yum -y install intel-mpi-2019.4-070.x86_64

## INSTALL INTEL RUNTIME DEPS ##
rpm --import https://yum.repos.intel.com/2019/setup/RPM-GPG-KEY-intel-psxe-runtime-2019
rpm -Uhv https://yum.repos.intel.com/2019/setup/intel-psxe-runtime-2019-reposetup-1-0.noarch.rpm
yum -y install intel-icc-runtime intel-ifort-runtime intel-mkl-runtime

## Install libfabric v1.7.1
wget https://github.com/ofiwg/libfabric/releases/download/v1.7.1/libfabric-1.7.1.tar.gz
tar -xf libfabric-1.7.1.tar.gz
cd libfabric-1.7.1/
./configure --prefix=/opt/libfabric --enable-mlx=no --enable-verbs=yes
make -j 40 && make install

cd && rm -rf /tmp/mpi

impi_path="
export PATH=/opt/libfabric/bin:\$PATH
export LD_LIBRARY_PATH=/opt/libfabric/lib:\$LD_LIBRARY_PATH "

#set env on /mnt/shared/ which can be used when launched after VM is generalized
echo -e "$impi_path" >> /mnt/shared/setenv

source /mnt/shared/setenv
