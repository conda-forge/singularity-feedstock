#!/bin/bash
set -euf

pushd src/github.com/sylabs/${PKG_NAME}

# configure
./mconfig \
  -P release-stripped \
  --without-suid \
  --without-network \
  -p "${PREFIX}" \
  -c "${CC}" \
  -x "${CXX}"

# build
pushd builddir
export LD_LIBRARY_PATH=${PREFIX}/lib
make

# install
make install

# Make Empty session dir
mkdir -p $PREFIX/var/singularity/mnt/session
touch $PREFIX/var/singularity/mnt/session/.mkdir
