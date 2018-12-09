#!/bin/bash
set -euf

export PATH=${GOPATH}/bin:$PATH
pushd src/github.com/sylabs/${PKG_NAME}

# bootstrap go dependencies
go get -u github.com/golang/dep/cmd/dep

export CFLAGS="${CFLAGS} -I${PREFIX}/include"
# configure
./mconfig \
  -v \
  -s \
  -S \
  -p $PREFIX \
  -c "$CC" \
  -C "$CC" \
  -x "$CPP" \
  -x "$CPP"

pushd builddir
# build
make 

# install
make install

# Move Singularity Network configuration files to PREFIX/etc/cni/net.d
mkdir -p $PREFIX/etc/cni/net.d
for i in `find $PREFIX/etc/singularity/network -maxdepth 1 -type f`; do
  mv $i $PREFIX/etc/cni/net.d
done
