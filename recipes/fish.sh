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

# Fish
fish_version="3.4.1"
fish_payload_name="fish-$fish_version"
wget "https://github.com/fish-shell/fish-shell/archive/refs/tags/$fish_version.tar.gz" -O "fish.download"

mkdir "$fish_payload_name"
mv fish.download "$fish_payload_name"
tree -L 1

cd "$fish_payload_name"
tar --strip-components=1 -xzf "fish.download" 

echo "Compiling fish-shell $fish_version"
mkdir build
cd build
cmake3 -DCMAKE_INSTALL_PREFIX="$INSTALL_DIR/fish" ..

echo "Running make.."
make

echo "Installing to $INSTALL_DIR/fish.."
make install

echo "Fish install done."
