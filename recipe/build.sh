#!/bin/bash
export PATH=${GOPATH}/bin:$PATH
pushd src/github.com/sylabs/${PKG_NAME}

# bootstrap go dependencies
go get -u github.com/golang/dep/cmd/dep

export CFLAGS="${CFLAGS} -I${PREFIX}/include"
# configure
./mconfig \
  -v \
  -p $PREFIX \
  -c "$CC" \
  -C "$CC" \
  -x "$CPP" \
  -x "$CPP"

# build
make -C builddir

# install
make -C builddir install
