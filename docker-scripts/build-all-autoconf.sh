#!/usr/bin/env bash

# Helper to build esbmc with autoconf
cd /home/esbmc/esbmc_src/src

if [ ! -f ./configure ]; then
    ./scripts/autoboot.sh
fi

cd /home/esbmc/esbmc_src
mkdir -p release-autoconf
mkdir -p build-autoconf
cd build-autoconf

CC=gcc
CFLAGS="-DNDEBUG -O3"

CXX=g++
CXXFLAGS="-DNDEBUG -O3"

solvers="--with-boolector=$BTOR_DIR --with-mathsat=$MATHSAT_DIR --with-z3=$Z3_DIR --with-yices=$YICES_DIR --with-cvc4=$CVC4_DIR"

destiny="--prefix=$PWD/../release-autoconf"

static_python="--enable-python --enable-static-link --disable-shared"

build_targets="--enable-esbmc --disable-libesbmc"

clang_dir="--with-clang=$CLANG_HOME --with-llvm=$CLANG_HOME"

flags="$destiny $clang_dir $build_targets $static_python $solvers --disable-werror"

../src/configure $flags
make -j`nproc`
make install
