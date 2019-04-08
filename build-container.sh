#!/bin/bash
set -ex

source /mnt/shared/setenv

pushd install-scripts
singularity build /mnt/shared/tensorflow/tf-hvd-gcc-ompi-ucx-mlnx.sif tf-hvd-gcc-ompi-ucx-mlnx.def
popd

#Run the container for sanity check.
singularity run /mnt/shared/tensorflow/tf-hvd-gcc-ompi-ucx-mlnx.sif
