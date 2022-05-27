#!/bin/bash
set -e

# To compile python, we're following the guide on:
# https://devguide.python.org/setup/

# Please note that https://vfxplatform.com/ doesn't specify the bugfix version,
# so we just try to stay aligned more or less with what

VERSION="3.7.7"

DEST_DIR="$1"
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

#if [ ! -v "CUSTOM_OPENSSL_PATH" ]; then
#    log_warning "This script is meant to be run by the CI."
#    log_warning "If you're running this manually, please set CUSTOM_OPENSSL_PATH to a valid path."
#    exit 0
#fi


# NB: when adding the checksum, take the one for "Gzipped source tarball"

case $VERSION in
    # blender/3.2.0 uses 3.10.2, but this should be close enough
    3.10.4)
        expected_md5="7011fa5e61dc467ac9a98c3d62cfe2be"
        ;;
    # What blender/3.0.1 uses
    3.9.6)
        expected_md5="798b9d3e866e1906f6e32203c4c560fa"
        ;;
    # What maya/2022 uses
    3.7.7)
        expected_md5="d348d978a5387512fbc7d7d52dd3a5ef"
        ;;
    # What we had on the floor since forever
    2.7.15)
        expected_md5="045fb3440219a1f6923fefdabde63342"
        ;;
    '')
        echo "[ERROR] Please specify a version to be built"
        exit 1
        ;;
    *)
        echo "[ERROR] No build support defined for version $VERSION"
        exit 1
        ;;
esac

release_url="https://www.python.org/ftp/python/$VERSION/Python-$VERSION.tgz"

python_payload_name="python-$VERSION"

echo "Downloading $release_url"
wget --quiet $release_url -O "python.download"
current_md5=$(md5sum python.download | awk '{print $1}')

if [ "$current_md5" != "$expected_md5" ]; then
    echo "[ERROR] MD5 mismatch. Expected: $expected_md5, found: $current_md5"
    exit 1
fi

mkdir "$python_payload_name"
mv python.download "$python_payload_name"
tree -L 1

cd "$python_payload_name"
tar --strip-components=1 -xzf "python.download"

echo "Running ./configure"

# The full list of flags is documented here: https://docs.python.org/dev/using/configure.html
# The most common would be:
#
# --with-pydebug
# This lets you create a debug build.
# See https://docs.python.org/dev/using/configure.html#debug-build
#
#    --enable-optimizations
# is not used for now since it runs tests that take a looot of time (2 hours)
#
#    --enable-shared
# If we were to enable building python as a .so, we'd need to put
# the resulting .so into /usr/lib64, or somewhere in the LD_LIBRARY_PATH
# eg: look at /usr/lib64/libpython2.7.so


# Temporarily set the RPATH to our custom build of OpenSSL
# This will let the linker link against this more recent version that we
# don't have currently have installed on the floor.
#export LD_RUN_PATH="$CUSTOM_OPENSSL_PATH/lib"
# Use it together with:
#    --with-openssl=$CUSTOM_OPENSSL_PATH \

./configure --with-system-ffi --prefix=$INSTALL_DIR/python3

echo "Compiling python $VERSION"
make -j

#unset LD_RUN_PATH

#echo "Running tests..."
# make test

# The above^ is commented for now since I'm getting failures and I don't know:
# - how relevant they are for us
# - if something is actually wrong
# - if it's a bug in python
# - if the tests are not written correctly
# Current results:
# FAILED (failures=1, skipped=30)
# test test_subprocess failed
# 3 tests failed again:
#     test_cmd_line test_subprocess test_tarfile

echo "Installing to $INSTALL_DIR/python3.."
make install

echo "python install done."
