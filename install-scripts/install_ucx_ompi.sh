#!/bin/bash
# Install communication runtimes and MPI libraries

set -ex

source /mnt/shared/setenv

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

ompi_path="export PATH=/opt/openmpi-4.0.0/bin:$PATH
export LD_LIBRARY_PATH=/opt/openmpi-4.0.0/lib:$LD_LIBRARY_PATH
export MANPATH=/opt/openmpi-4.0.0/share/man:$MANPATH
export MPI_BIN=/opt/openmpi-4.0.0/bin
export MPI_INCLUDE=/opt/openmpi-4.0.0/include
export MPI_LIB=/opt/openmpi-4.0.0/lib
export MPI_MAN=/opt/openmpi-4.0.0/share/man
export MPI_HOME=/opt/openmpi-4.0.0"

echo -e "$ompi_path" >> /mnt/shared/setenv

source /mnt/shared/setenv
