#!/bin/bash
set -ex

# Install dev_tools, MLNX OFED driver, IPoIB, WALinuxAgent, gcc 8.2, UCX1.5, OpenMPI4.0, Singularity libraries

if [ $# != 1 ]; then
    echo "\nMissing arguments. Usage: setup-host-and-build-container.sh <intelmpi|openmpi> \n"
    exit 1
fi

# Used to save setenv file with all the ENV PATHS
mkdir -p /mnt/shared/
chmod -R 777 /mnt/shared/

pushd install-scripts

if [ "$1" == "intelmpi" ]; then
    ./setup.sh intelmpi host
    ./build-container.sh intelmpi
elif [ "$1" == "openmpi" ]; then
    ./setup.sh openmpi host
    ./build-container.sh openmpi
else
    echo "\n Argument error. Use <intelmpi|openmpi>. Usage: setup.sh <intelmpi|openmpi> \n"
    exit 1
fi

popd
