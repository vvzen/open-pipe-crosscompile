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

# tmux
tmux_version="3.2a"
tmux_payload_name="tmux-$tmux_version"
wget --quiet "https://github.com/tmux/tmux/archive/refs/tags/$tmux_version.tar.gz" -O "tmux.download"

mkdir "$tmux_payload_name"
mv tmux.download "$tmux_payload_name"
tree -L 1

cd "$tmux_payload_name"
tar --strip-components=1 -xzf "tmux.download"

ls -hal
echo "Compiling tmux-$tmux_version"
sh ./autogen.sh
./configure --prefix=$INSTALL_DIR/tmux

echo "Running make.."
make

echo "Installing to $INSTALL_DIR/tmux.."
make install

echo "tmux install done."
