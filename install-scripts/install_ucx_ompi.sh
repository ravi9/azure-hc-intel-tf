#!/bin/bash
# Install communication runtimes and MPI libraries

set -ex

export PATH=/opt/gcc-8.2.0/bin:$PATH
export LD_LIBRARY_PATH=/opt/gcc-8.2.0/lib64:$LD_LIBRARY_PATH
export CC=/opt/gcc-8.2.0/bin/gcc
export GCC=/opt/gcc-8.2.0/bin/gcc

INSTALL_PREFIX=/opt

mkdir -p /tmp/mpi
cd /tmp/mpi

# UCX 1.5.0
wget https://github.com/openucx/ucx/releases/download/v1.5.0/ucx-1.5.0.tar.gz
tar -xvf ucx-1.5.0.tar.gz
cd ucx-1.5.0
./contrib/configure-release --prefix=${INSTALL_PREFIX}/ucx-1.5.0 && make -j 40 && make install
cd ..

# OpenMPI 4.0.0
wget https://download.open-mpi.org/release/open-mpi/v4.0/openmpi-4.0.0.tar.gz
tar -xvf openmpi-4.0.0.tar.gz
cd openmpi-4.0.0
./configure --prefix=${INSTALL_PREFIX}/openmpi-4.0.0 --with-ucx=${INSTALL_PREFIX}/ucx-1.5.0 --enable-mpirun-prefix-by-default && make -j 40 && make install
cd ..

cd && rm -rf /tmp/mpi
