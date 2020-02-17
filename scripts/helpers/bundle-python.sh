#!/bin/bash

# Bundle the python runtime
PYTHON_PREFIX=$(pkg-config --variable=prefix python)
PYTHON_LIBDIR=$(pkg-config --variable=libdir python)
PYTHON_VERSION=$(pkg-config --modversion python)
if [ -z "${PYTHON_PREFIX}" ]; then
    echo "Could not determine PYTHON installation prefix, exiting."
    exit 1
fi
if [ -z "${PYTHON_LIBDIR}" ]; then
    echo "Could not determine PYTHON library path, exiting."
    exit 1
fi
if [ -z "${PYTHON_VERSION}" ]; then
    echo "Could not determine PYTHON version, exiting."
    exit 1
fi

set -e

cp -a "${PYTHON_PREFIX}/bin"/python* "$APPDIR/usr/bin"
rm -rf "$APPDIR/usr/lib/python${PYTHON_VERSION}"
mkdir -p "$APPDIR/usr/lib"
cp -a "${PYTHON_LIBDIR}/python${PYTHON_VERSION}" "$APPDIR/usr/lib"


mkdir -p "$APPDIR/usr/lib64"
cd "$APPDIR/usr/lib64"
rm -rf python"${PYTHON_VERSION}"
ln -s ../lib/python"${PYTHON_VERSION}" .
cd -

# Remove some stuff we don't need

cd "$APPDIR/usr/lib/python${PYTHON_VERSION}/site-packages/numpy/"
rm -f ./linalg/lapack_lite.so && touch ./linalg/lapack_lite.py
rm -f ./core/_dotblas.so && touch ./core/_dotblas.py


echo "Python bundling finished"
