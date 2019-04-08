#!/bin/bash
# Install OSU benchmarks.

set -ex

export PATH=/opt/gcc-8.2.0/bin:$PATH
export LD_LIBRARY_PATH=/opt/gcc-8.2.0/lib64:$LD_LIBRARY_PATH
export CC=/opt/gcc-8.2.0/bin/gcc
export GCC=/opt/gcc-8.2.0/bin/gcc

export PATH=/opt/openmpi-4.0.0/bin:$PATH
export LD_LIBRARY_PATH=/opt/openmpi-4.0.0/lib:$LD_LIBRARY_PATH
export MANPATH=/opt/openmpi-4.0.0/share/man:$MANPATH
export MPI_BIN=/opt/openmpi-4.0.0/bin
export MPI_INCLUDE=/opt/openmpi-4.0.0/include
export MPI_LIB=/opt/openmpi-4.0.0/lib
export MPI_MAN=/opt/openmpi-4.0.0/share/man
export MPI_HOME=/opt/openmpi-4.0.0

INSTALL_PREFIX=/opt

mkdir -p /tmp/osu
cd /tmp/osu

wget http://mvapich.cse.ohio-state.edu/download/mvapich/osu-micro-benchmarks-5.6.1.tar.gz
tar -xf osu-micro-benchmarks-5.6.1.tar.gz
cd osu-micro-benchmarks-5.6.1
./configure CC=/opt/openmpi-4.0.0/bin/mpicc CXX=/opt/openmpi-4.0.0/bin/mpicxx --prefix=${INSTALL_PREFIX}/osu/
make -j 40 && make install

cd && rm -rf /tmp/osu
