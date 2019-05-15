#!/bin/bash
# Install communication runtimes and MPI libraries

set -ex

source /mnt/shared/setenv

INSTALL_PREFIX=/opt

mkdir -p /tmp/mpi
cd /tmp/mpi

# UCX 1.5.1
wget https://github.com/openucx/ucx/releases/download/v1.5.1/ucx-1.5.1.tar.gz
tar -xvf ucx-1.5.1.tar.gz
cd ucx-1.5.1
./contrib/configure-release --prefix=${INSTALL_PREFIX}/ucx-1.5.1 && make -j 8 && make install
cd ..

# OpenMPI 4.0.1
wget https://download.open-mpi.org/release/open-mpi/v4.0/openmpi-4.0.1.tar.gz
tar -xvf openmpi-4.0.1.tar.gz
cd openmpi-4.0.1
./configure --prefix=${INSTALL_PREFIX}/openmpi-4.0.1 --with-ucx=${INSTALL_PREFIX}/ucx-1.5.1 --enable-mpirun-prefix-by-default && make -j 8 && make install
cd ..

cd && rm -rf /tmp/mpi

ompi_path="export PATH=/opt/openmpi-4.0.1/bin:$PATH
export LD_LIBRARY_PATH=/opt/openmpi-4.0.1/lib:$LD_LIBRARY_PATH
export MANPATH=/opt/openmpi-4.0.1/share/man:$MANPATH
export MPI_BIN=/opt/openmpi-4.0.1/bin
export MPI_INCLUDE=/opt/openmpi-4.0.1/include
export MPI_LIB=/opt/openmpi-4.0.1/lib
export MPI_MAN=/opt/openmpi-4.0.1/share/man
export MPI_HOME=/opt/openmpi-4.0.1"

echo -e "$ompi_path" >> /mnt/shared/setenv

source /mnt/shared/setenv
