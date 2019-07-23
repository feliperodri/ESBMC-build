#!/bin/bash

# This will compile ESBMC using all sovers using python and static linking

cd /home/esbmc/esbmc_src
mkdir -p cmake-build
mkdir -p release
cd cmake-build
cmake ../src -DCMAKE_INSTALL_PREFIX=../release -DCMAKE_BUILD_TYPE=Release -DENABLE_PYTHON=ON -DBUILD_STATIC=ON -G Ninja -DMSAT_DIR=$MATHSAT_DIR -DBTOR_DIR=$BTOR_DIR -DZ3_DIR=$Z3_DIR -DYICES_DIR=$YICES_DIR -DCVC4_DIR=$CVC4_DIR -DLLVM_DIRECTORY=$CLANG_HOME
ninja
cp ./esbmc/esbmc ../release/
