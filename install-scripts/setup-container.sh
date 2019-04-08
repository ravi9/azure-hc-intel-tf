#!/bin/bash
set -ex

# Update memory limits
./update_config.sh

# Install development tools
./install_dev_tools.sh

# Install OFED, setup IPoIB, and WALinuxAgent
./install_ofed.sh

# Install gcc 8.2
./install_gcc-8.2.sh

# Install UCX1.5 and OPENMPI4.0 libraries
./install_ucx_ompi.sh

#ENV paths are setup in the "%environment section of Singularity .def files.

# Install miniconda, intel-tensorflow, horovod libraries
./install_conda_tf_hvd.sh

