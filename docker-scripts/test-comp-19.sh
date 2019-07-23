#!/usr/bin/env bash

# This will configure an environment similar to the used in the TestComp'19
cd /home/esbmc/esbmc_src

if [ ! -d sv-benchmarks ]; then
  wget https://github.com/sosy-lab/sv-benchmarks/archive/testcomp19.tar.gz -O testcomp19.tar.gz
  tar xf testcomp19.tar.gz
  rm testcomp19.tar.gz
  mv sv-benchmarks-testcomp19 sv-benchmarks
fi

cd sv-benchmarks

if [ ! -d benchmark ]; then
    mkdir benchmark
fi

if [ ! -f ../esbmc-def.xml ]; then
    wget https://gitlab.com/sosy-lab/test-comp/bench-defs/raw/master/benchmark-defs/esbmc-falsi.xml \
         -O esbmc-def.xml
else
    cp ../esbmc-def.xml .
fi

cp ../esbmc-wrapper.py .
cp ../release/esbmc .

rm -rf /home/esbmc/esbmc_src/testcomp/

benchexec ./esbmc-def.xml \
          --no-container \
          --output /home/esbmc/esbmc_src/testcomp/output.log\
          --limitCores 1 \
          --memorylimit "${1}GB" \
          --numOfThreads $2

table-generator '/home/esbmc/esbmc_src/testcomp/output.*.xml.bz2'

chmod -R a+rwX /home/esbmc/esbmc_src/testcomp/
