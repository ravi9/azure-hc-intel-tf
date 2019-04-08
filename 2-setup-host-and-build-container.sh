#!/bin/bash
set -ex

mkdir -p /mnt/shared/tensorflow
chmod -R 777 /mnt/shared/

# Install dev_tools, MLNX OFED driver, IPoIB, WALinuxAgent, gcc 8.2, UCX1.5, OpenMPI4.0, Singularity libraries
./setup-host.sh

source /mnt/shared/setenv

pushd install-scripts
singularity build /mnt/shared/tensorflow/tf-hvd-gcc-ompi-ucx-mlnx.sif tf-hvd-gcc-ompi-ucx-mlnx.def
popd

#Run the container for sanity check.
singularity run /mnt/shared/tensorflow/tf-hvd-gcc-ompi-ucx-mlnx.sif