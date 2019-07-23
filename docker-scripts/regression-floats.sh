#!/usr/bin/env bash

# This will search for ESBMC binary in the release directory

cd /home/esbmc/esbmc_src
export PATH=$PWD/release:$PATH

cd regression/floats
make clean
make default
