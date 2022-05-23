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

helixeditor_version="22.03"
helixeditor_payload_name="helixeditor-$helixeditor_version"
wget --quiet "https://github.com/helix-editor/helix/releases/download/$helixeditor_version/helix-$helixeditor_version-source.tar.xz" -O "helixeditor.download"

mkdir "$helixeditor_payload_name"
mv helixeditor.download "$helixeditor_payload_name"
tree -L 1

cd "$helixeditor_payload_name"
tar --strip-components=1 -xf "helixeditor.download" 

export PATH="~/.cargo/bin:$PATH"

which gcc
gcc --version

cargo build --release --target-dir "$INSTALL_DIR/helix-editor"

echo "helix-editor install done."
