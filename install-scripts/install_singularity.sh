#!/bin/bash

set -x

yum install -y golang openssl-devel libuuid-devel libseccomp-devel squashfs-tools

yum install -y rpm-build wget

export SINGVERSION=3.1.0  # this is the singularity version, change as you need

wget https://github.com/sylabs/singularity/releases/download/v${SINGVERSION}/singularity-${SINGVERSION}.tar.gz && \
    rpmbuild -tb singularity-${SINGVERSION}.tar.gz && \
    rpm -ivh ~/rpmbuild/RPMS/x86_64/singularity-${SINGVERSION}-1.el7.x86_64.rpm && \
    rm -rf ~/rpmbuild singularity-${SINGVERSION}*.tar.gz

