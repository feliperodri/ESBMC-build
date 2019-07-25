#!/usr/bin/env bash

# Helper to build esbmc with autoconf
cd /home/esbmc/esbmc_src/src
#./scripts/autoboot.sh

cd /home/esbmc/esbmc_src
mkdir -p release-autoconf
mkdir -p build-autoconf
cd build-autoconf

CC=$CLANG_HOME/bin/clang
CFLAGS="-DNDEBUG -O3"

CXX=$CLANG_HOME/bin/clang++
CXXFLAGS="-DNDEBUG -O3"

solvers="--with-boolector=$BTOR_DIR --with-mathsat=$MATHSAT_DIR --with-z3=$Z3_DIR --with-yices=$YICES_DIR --with-cvc4=$CVC4_DIR"

destiny="--prefix=$PWD/../release-autoconf"

static_python="--enable-python --enable-static-link --disable-shared"

build_targets="--enable-esbmc --enable-libesbmc"

clang_dir="--with-clang=$CLANG_HOME --with-llvm=$CLANG_HOME"

flags="$destiny $cxx_compiler  $clang_dir $build_targets $static_python $solvers"

../src/configure $flags
make -j8
make install
