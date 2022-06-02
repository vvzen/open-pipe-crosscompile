#!/bin/bash

set -e
set -u

DEST_DIR=$1

INSTALL_DIR="$DEST_DIR/install"
DOWNLOAD_DIR="$DEST_DIR/download"

VERSION="2.36.1"
NAME="git"
PREFIX="$INSTALL_DIR/$NAME"
PAYLOAD_NAME="$NAME-$VERSION"
DOWNLOAD_NAME="$NAME.download"
URL="https://github.com/git/git/archive/refs/tags/v$VERSION.tar.gz"

if [ ! -d "$DEST_DIR" ]; then
    echo "$DEST_DIR doesn't exist, creating it.."
    mkdir -p "$DEST_DIR"
fi

mkdir -p $DOWNLOAD_DIR
mkdir -p $INSTALL_DIR

echo "Downloading payloads to $DOWNLOAD_DIR"
cd $DOWNLOAD_DIR

wget "$URL" -O "$DOWNLOAD_NAME"

mkdir "$PAYLOAD_NAME"
mv "$DOWNLOAD_NAME" "$PAYLOAD_NAME"
tree -L 1

cd "$PAYLOAD_NAME"
tar --strip-components=1 -xzf "$DOWNLOAD_NAME" 


echo "Running configure script"
make configure
./configure --prefix=$PREFIX

echo "Compiling $NAME $VERSION"
make all doc

echo "Installing to $PREFIX.."
make install install-doc install-html install-info

echo "$NAME install done."
