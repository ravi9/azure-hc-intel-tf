#!/bin/bash
# Install miniconda3, tensorflow, Horovod, tf_cnn_benchmarks

set -ex

# Set ENV for GCC and MPI
source /mnt/shared/setenv

INSTALL_PREFIX=/opt

wget https://repo.continuum.io/miniconda/Miniconda3-latest-Linux-x86_64.sh
bash Miniconda3-latest-Linux-x86_64.sh -b -p ${INSTALL_PREFIX}/miniconda3

export PATH=${INSTALL_PREFIX}/miniconda3/bin:$PATH
rm -rf Miniconda3-latest-Linux-x86_64.sh

conda install -y tensorflow
pip install --no-cache-dir Horovod

tfversion=$(python -c "import tensorflow as tf;print(tf.__version__)")
tf_ver_rel_arr=(${tfversion//./ })  # Parse version and release
tf_ver=${tf_ver_rel_arr[0]}
tf_rel=${tf_ver_rel_arr[1]}

# Clone benchmark scripts for appropriate TF version
git clone -b cnn_tf_v${tf_ver}.${tf_rel}_compatible  https://github.com/tensorflow/benchmarks.git ${INSTALL_PREFIX}/tensorflow-benchmarks
