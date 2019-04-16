#!/bin/bash
# Install OSU benchmarks.

set -ex

source /mnt/shared/setenv

INSTALL_PREFIX=/opt

mkdir -p /tmp/osu
cd /tmp/osu

wget http://mvapich.cse.ohio-state.edu/download/mvapich/osu-micro-benchmarks-5.6.1.tar.gz
tar -xf osu-micro-benchmarks-5.6.1.tar.gz
cd osu-micro-benchmarks-5.6.1
./configure CC=`which mpicc` CXX=`which mpicxx` --prefix=${INSTALL_PREFIX}/osu/
make -j 40 && make install

cd && rm -rf /tmp/osu