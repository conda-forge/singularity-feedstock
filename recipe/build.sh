#!/bin/bash
set -euf

export PATH=${GOPATH}/bin:$PATH
pushd src/github.com/sylabs/${PKG_NAME}

# bootstrap go dependencies
go get -u github.com/golang/dep/cmd/dep

# Create a C and CPP compiler for singularity
cat > singularity-cc <<_EOF
#!/usr/bin/env bash
exec $CC -I${PREFIX}/include -L${PREFIX}/lib \$@
_EOF
chmod 755 singularity-cc

cat > singularity-cxx <<_EOF
#!/usr/bin/env bash
exec $CPP -I${PREFIX}/include -L${PREFIX}/lib \$@
_EOF
chmod 755 singularity-cxx

export CPPFLAGS=${CPPFLAGS/-fno-plt/}
export CFLAGS=${CFLAGS/-fno-plt/}
# configure
./mconfig \
  -v \
  -p $PREFIX \
  -c "${PWD}/singularity-cc" \
  -x "${PWD}/singularity-cxx"

pushd builddir
# build
export CGO_CPPFLAGS=${CPPFLAGS}
export CGO_LDFLAGS=${LDFLAGS}
make

# install
make install

# Move Singularity Network configuration files to PREFIX/etc/cni/net.d
mkdir -p $PREFIX/etc/cni/net.d
for i in `find $PREFIX/etc/singularity/network -maxdepth 1 -type f`; do
  mv $i $PREFIX/etc/cni/net.d
done
