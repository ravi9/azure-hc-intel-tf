#!/bin/bash
set -ex

if [ $# != 1 ]; then
    echo "\nMissing arguments. Usage: build-container.sh <intelmpi|openmpi> \n"
    exit 1
fi

if [ "$1" == "intelmpi" ]; then
    PREFIX=tf-hvd-gcc-impi-libfabric-mlnx
elif [ "$1" == "openmpi" ]; then
    PREFIX=tf-hvd-gcc-ompi-ucx-mlnx
else
    echo "\n Argument error. Use <intelmpi|openmpi>. Usage:  build-container.sh <intelmpi|openmpi>  \n"
    exit 1
fi

source /mnt/shared/setenv

mkdir -p /mnt/shared/tensorflow
chmod -R 777 /mnt/shared/

SIF_PATH=/mnt/shared/tensorflow/${PREFIX}.sif
DEF_FILE=${PREFIX}.def

# Build singularity Image
singularity build $SIF_PATH $DEF_FILE

# Run the container for sanity check.
singularity run $SIF_PATH
