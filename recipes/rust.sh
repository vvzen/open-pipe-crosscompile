#!/bin/bash

set -e
set -u

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

rustup_version="1.61.0"
rustup_payload_name="rustup-$rustup_version"
wget "https://static.rust-lang.org/dist/rust-$rustup_version-aarch64-unknown-linux-gnu.tar.gz" -O "rustup.download"

mkdir "$rustup_payload_name"
mv rustup.download "$rustup_payload_name"
tree -L 1

cd "$rustup_payload_name"
tar --strip-components=1 -xzf "rustup.download" 

echo "Installing rust-$rustup_version"
./install.sh

echo "rustup install done."
