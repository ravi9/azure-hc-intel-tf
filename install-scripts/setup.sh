#!/bin/bash

# Usage: setup.sh <intelmpi|openmpi> <host|container>

set -ex

function install_common {
    # Update memory limits
    ./update_config.sh

    # Install development tools
    ./install_dev_tools.sh

    # Install OFED, setup IPoIB, and WALinuxAgent
    ./install_ofed.sh

    # Install gcc 8.2
    ./install_gcc-8.2.sh

}

function install_host_deps {
    #Install Singularity
    ./install_singularity.sh
}

function install_container_deps {
    # Install miniconda, intel-tensorflow, horovod libraries
    ./install_conda_tf_hvd.sh
}

function install_intelmpi {
    #Install Singularity
    ./install_libfabric_impi.sh
}

function install_openmpi {
    # Install miniconda, intel-tensorflow, horovod libraries
    ./install_ucx_ompi.sh
}

if [ $# != 2 ]; then
    echo "\nMissing arguments. Usage: setup.sh <intelmpi|openmpi> <host|container> \n"
    exit 1
fi

if [ "$1" == "intelmpi" ]; then
    MPI_INSTALL="install_intelmpi"
elif [ "$1" == "openmpi" ]; then
    MPI_INSTALL="install_openmpi"
else
    echo "\n Argument error. Use <intelmpi|openmpi>. Usage: setup.sh <intelmpi|openmpi> <host|container> \n"
    exit 1
fi

if [ "$2" == "host" ]; then
    echo "Starting HOST setup..."
    install_common
    $MPI_INSTALL
    install_host_deps
elif [ "$2" == "container" ]; then
    echo "Starting CONTAINER setup..."
    install_common
    $MPI_INSTALL
    install_container_deps
else
    echo "\n Argument error. Use <host|container>. Usage: setup.sh <intelmpi|openmpi> <host|container> \n"
    exit 1
fi

echo -e "
########################################################
Run 'source /mnt/shared/setenv' to set paths for GCC and MPI
######################################################## "

#cd to azure-hc-intel-tf
popd