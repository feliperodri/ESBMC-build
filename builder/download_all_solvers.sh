#!/bin/bash

# - Boolector
cd /home/esbmc/
git clone https://github.com/boolector/boolector
cd /home/esbmc/boolector
./contrib/setup-lingeling.sh && ./contrib/setup-btor2tools.sh && ./configure.sh && cd build && make -j9

# - Z3
cd /home/esbmc
wget https://github.com/Z3Prover/z3/releases/download/z3-4.8.4/z3-4.8.4.d6df51951f4c-x64-ubuntu-16.04.zip \
    && unzip z3-4.8.4.d6df51951f4c-x64-ubuntu-16.04.zip && mv z3-4.8.4.d6df51951f4c-x64-ubuntu-16.04 z3 \
    && rm z3-4.8.4.d6df51951f4c-x64-ubuntu-16.04.zip

# - GMP. I couldn't compile Yices with static gmp from ubuntu
cd /home/esbmc/
wget https://gmplib.org/download/gmp/gmp-6.1.2.tar.xz \
    && tar xf gmp-6.1.2.tar.xz && rm gmp-6.1.2.tar.xz && cd /home/esbmc/gmp-6.1.2 \
    && ./configure --prefix /home/esbmc/gmp --disable-shared ABI=64 CFLAGS=-fPIC CPPFLAGS=-DPIC \
    && make -j4 && make install && cd /home/esbmc && rm -rf /home/esbmc/gmp-6.1.2

# - Mathsat
cd /home/esbmc/
wget http://mathsat.fbk.eu/download.php?file=mathsat-5.5.4-linux-x86_64.tar.gz -O mathsat.tar.gz \
    && tar xf mathsat.tar.gz && rm mathsat.tar.gz

# - Yices
cd /home/esbmc/
wget http://yices.csl.sri.com/releases/2.6.1/yices-2.6.1-src.tar.gz \
    && tar xf yices-2.6.1-src.tar.gz && rm yices-2.6.1-src.tar.gz && cd /home/esbmc/yices-2.6.1 \
    && ./configure --prefix /home/esbmc/yices --with-static-gmp=/home/esbmc/gmp/lib/libgmp.a \
    &&  make && make static-lib && make install \
    && cp ./build/x86_64-pc-linux-gnu-release/static_lib/libyices.a /home/esbmc/yices/lib \
    && rm -rf /home/esbmc/yices-2.6.1

# - CVC4 free
cd /home/esbmc/
wget https://github.com/CVC4/CVC4/archive/1.7.tar.gz \
    && tar xf 1.7.tar.gz && rm 1.7.tar.gz && cd /home/esbmc/CVC4-1.7 \
    && ./contrib/get-antlr-3.4 && ./configure.sh --optimized --prefix=/home/esbmc/cvc4 --static --no-static-binary \
    && cd /home/esbmc/CVC4-1.7/build && make -j8 && make install && rm -rf /home/esbmc/CVC4-1.7

cd /home/esbmc/
