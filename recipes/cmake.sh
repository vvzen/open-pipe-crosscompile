#!/bin/bash

set -e

DEST_DIR=$1
DOWNLOAD_DIR="$DEST_DIR/download"
INSTALL_DIR="$DEST_DIR/install"

if [ ! -d "$DEST_DIR" ]; then
    echo "$DEST_DIR doesn't exist, creating it.."
    mkdir -p "$DEST_DIR"
fi

mkdir -p $DOWNLOAD_DIR
mkdir -p $INSTALL_DIR

echo "Downloading payloads to $DOWNLOAD_DIR"
cd $DOWNLOAD_DIR

# Cmake3, since there's no yum package
cmake_version="3.12.3"
cmake_payload_name="cmake_$cmake_version"
wget "https://cmake.org/files/v3.12/cmake-$cmake_version.tar.gz" -O "cmake3.download"
mkdir $cmake_payload_name
mv "cmake3.download" $cmake_payload_name
cd $cmake_payload_name

tar --strip-components=1 -xzf "cmake3.download"
ls -hal

echo "Compiling cmake-${cmake_version}.."
./bootstrap --prefix="$INSTALL_DIR/cmake3"
make -j 1

echo "Installing cmake-${cmake_version}.."
make install


echo "cmake3 install completed."