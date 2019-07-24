[![Build Status](https://travis-ci.com/rafaelsamenezes/ESBMC-build.svg?branch=master)](https://travis-ci.com/rafaelsamenezes/ESBMC-build)

# ESBMC-build
This is a Docker environment to help build ESBMC, run regressions and run benchmarks. This is still a WIP, if you have any problems please file an issue!

**ATENTION: Always run `docker pull rafaelsamenezes/esbmc-cmake` any time this repository changes so that you have the latest
image**

## Prerequisites
- Docker
- ESBMC repo in the cmake branch

## Recipes

### Build ESBMC with all solvers and python using static linkage
1. Copy `./scripts/boostrap.sh` into the esbmc folder.
1. Go to to the esbmc folder.
1. Run `bootstrap.sh`
1. Press 1 and then 6.
1. The builded file will be located inside the `release` folder

### Execute Regression
0. Build esbmc using the previous recipe or put an ESBMC build inside the
   release folder in the esbmc root directory.
0. Copy `./scripts/boostrap.sh` into the esbmc folder.
0. Go to to the esbmc folder.
0. Run `bootstrap.sh`
0. Press 2 and then select which regression do you want to use.
0. At the end of the execution a summary will be shown, and the tests.log file
  will be generated inside the regression folder.

### Execute TestComp'19 benchmark
0. Build esbmc using the previous recipe or put an ESBMC build inside the
   release folder in the esbmc root directory.
0. Copy `./scripts/boostrap.sh` into the esbmc folder.
0. *Optional: Copy `./scripts/esbmc-def.xml`  and `./scripts/esbmc-wrapper.py` 
  into the esbmc folder. This step should only be done if you are testing if everything
  is working or if you want to run a custom configuration e.g setting different categories*
0. Go to to the esbmc folder.
0. Run `bootstrap.sh`
0. Press 3 and then 1.
0. When asked about how much RAM do you want to give to the machine, think about how many threads
  do you want, and multiply it by the quantity of RAM that you'd like per thread. Example: To run 8 threads
  with 16GB each you should put 128.
0. Put how many threads will be used
0. The report will be inside the esbmc root folder inside the folder `testcomp`

