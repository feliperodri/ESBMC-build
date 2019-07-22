###################################
# NOTES
###################################

# This docker environment will be used as a base to build ESBMC in static mode with python
# It currently works by providing an ubuntu 18.04 environment with the following tools:

# - Clang 7
# - CVC4
# - Yices
# - Z3
# - Boolector
# - Mathsat

# All solvers are compiled statically

# I am removing libgomp.so only because autoconf told me to do it. So... why?

###################################
# TODO
###################################

# Reduce image size
# - This really should use a multi-stage build
# - Maybe use alpine instead of ubuntu to reduce size. Also, if it works on alpine
#   it WILL work on any *nix

# DockerHub
# - After this dockerfile is ready, we should send to dockerhub as the supported
#   version (and update it with time)

###################################
# START
###################################
FROM ubuntu:18.04

###################################
# ROOT
###################################

# Update the repository sources list
RUN apt-get update && apt-get upgrade -y -qq

# Core Packages
RUN apt-get install -y git \
    build-essential \
    wget \
    bison \
    flex \
    unzip \
    gcc-multilib \
    linux-libc-dev \
    libzip-dev \
    libtinfo-dev \
    libxml2-dev \
    libboost-all-dev

# Automake Packages
RUN apt-get install -y automake \
    pkg-config \
    libtool

# CMake Packages
RUN apt-get install -y cmake ninja-build

# Download Clang 7
WORKDIR /usr/local/opt
RUN wget http://releases.llvm.org/7.0.1/clang+llvm-7.0.1-x86_64-linux-gnu-ubuntu-18.04.tar.xz -O clang.tar.xz
RUN tar xf clang.tar.xz
RUN rm clang.tar.xz
RUN mv clang+llvm-7.0.1-x86_64-linux-gnu-ubuntu-18.04 clang7
# HACK: Remove libgomp.so not sure why we do this but autoconf gives an error with we don't.
RUN rm ./clang7/lib/libgomp.so
ENV CLANG_HOME=/usr/local/opt/clang7

# Extra (for solvers)
RUN apt-get install -y gperf libgmp-dev # Yices
RUN apt-get install -y openjdk-8-jdk # CVC4

# For faster incremental builds
RUN apt-get install -y ccache
 
# Clean packages installation
RUN apt-get clean

# Create default user
RUN useradd -m esbmc

###################################
# local user
###################################

USER esbmc
# This folder should be used as external repo
RUN mkdir /home/esbmc/esbmc-private
VOLUME /home/esbmc/esbmc-private

##################################
# Building all solvers
##################################

# - Boolector
WORKDIR /home/esbmc/
RUN git clone https://github.com/boolector/boolector
WORKDIR /home/esbmc/boolector
RUN ./contrib/setup-lingeling.sh
RUN ./contrib/setup-btor2tools.sh
RUN ./configure.sh && cd build && make -j9
ENV BTOR_DIR=/home/esbmc/boolector

# - Z3
WORKDIR /home/esbmc
RUN wget https://github.com/Z3Prover/z3/releases/download/z3-4.8.4/z3-4.8.4.d6df51951f4c-x64-ubuntu-16.04.zip
RUN unzip z3-4.8.4.d6df51951f4c-x64-ubuntu-16.04.zip
RUN mv z3-4.8.4.d6df51951f4c-x64-ubuntu-16.04 z3
RUN rm z3-4.8.4.d6df51951f4c-x64-ubuntu-16.04.zip
ENV Z3_DIR=/home/esbmc/z3

# - GMP. I couldn't compile Yices with static gmp from ubuntu
WORKDIR /home/esbmc/
RUN wget https://gmplib.org/download/gmp/gmp-6.1.2.tar.xz
RUN tar xf gmp-6.1.2.tar.xz
RUN rm gmp-6.1.2.tar.xz
WORKDIR /home/esbmc/gmp-6.1.2
RUN ./configure --prefix /home/esbmc/gmp --disable-shared ABI=64 CFLAGS=-fPIC CPPFLAGS=-DPIC
RUN make -j4
RUN make install

# - Mathsat
WORKDIR /home/esbmc/
RUN wget http://mathsat.fbk.eu/download.php?file=mathsat-5.5.4-linux-x86_64.tar.gz -O mathsat.tar.gz
RUN tar xf mathsat.tar.gz
RUN rm mathsat.tar.gz
ENV MATHSAT_DIR=/home/esbmc/mathsat-5.5.4-linux-x86_64

# - Yices
WORKDIR /home/esbmc/
RUN wget http://yices.csl.sri.com/releases/2.6.1/yices-2.6.1-src.tar.gz
RUN tar xf yices-2.6.1-src.tar.gz
RUN rm yices-2.6.1-src.tar.gz
WORKDIR /home/esbmc/yices-2.6.1
RUN ./configure --prefix /home/esbmc/yices --with-static-gmp=/home/esbmc/gmp/lib/libgmp.a
RUN make 
RUN make static-lib
RUN make install
RUN cp ./build/x86_64-pc-linux-gnu-release/static_lib/libyices.a /home/esbmc/yices/lib
ENV YICES_DIR=/home/esbmc/yices


# - CVC4 free
WORKDIR /home/esbmc/
RUN wget https://github.com/CVC4/CVC4/archive/1.7.tar.gz
RUN tar xf 1.7.tar.gz
RUN rm 1.7.tar.gz
WORKDIR /home/esbmc/CVC4-1.7
RUN ./contrib/get-antlr-3.4
RUN ./configure.sh --optimized --prefix=/home/esbmc/cvc4 --static --no-static-binary 
WORKDIR /home/esbmc/CVC4-1.7/build
RUN make -j8
RUN make install
ENV CVC4_DIR=/home/esbmc/cvc4

WORKDIR /home/esbmc/
