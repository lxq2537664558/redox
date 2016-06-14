#!/usr/bin/env bash
# Build script for continuous integration
set -ev
env | sort

# Install packages
sudo apt-get update
sudo apt-get install -y libhiredis-dev libev-dev libgtest-dev redis-server

# Clean
rm -rf build
mkdir build
cd build

# Make gtest
git clone https://github.com/google/googletest
cd googletest
mkdir build
cd build
cmake -DBUILD_GMOCK=OFF -DBUILD_GTEST=ON -DBUILD_SHARED_LIBS=ON ..
time make
sudo mv googletest/libg* /usr/local/lib/
cd ../..

# Make redox
cmake -Dexamples=ON -Dlib=ON -Dstatic_lib=ON -Dtests=ON ..
time make
./test_redox
cd ..
