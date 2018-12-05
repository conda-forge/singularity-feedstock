#!/bin/bash
# Turn the work-folder into GOPATH
export GOPATH=${SRC_DIR}
export PATH=${GOPATH}/bin:$PATH
pushd src/github.com/sylabs/${PKG_NAME}

# bootstrap go dependencies
go get -u github.com/golang/dep/cmd/dep

# Git Initialize
# Apps tend to use git info to create version string
git init
git config --local user.email "conda@conda-forge.github.io"
git config --local user.name "conda-forge"

echo $PKG_VERSION >> .conda_version
git add .conda_version
git commit -m "conda build of $PKG_NAME-v$PKG_VERSION"
git tag v${PKG_VERSION}



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
