#!/usr/bin/env python3

from benchmark_base import Benchmark
"""Helper script to download tools from test-comp"""

PREFIX = "/home/rafaelsa/Git/esbmc-private-cmake"
DESTINY = PREFIX + "/test-comp19"

class TestComp19(Benchmark):

    def benchmark_url(self):
        return "https://github.com/sosy-lab/sv-benchmarks/archive/testcomp19.tar.gz"

    def benchmark_destiny(self):
        return self.destiny + "/sv-benchmarks-testcomp19"
