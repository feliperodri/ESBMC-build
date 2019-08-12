"""Module to help prepare environment for SV/Test Competition"""

import os
from shutil import copyfile, unpack_archive
import logging
import multiprocessing
import requests
import signal
from benchexec.runexecutor import RunExecutor

class Tool():

    def __init__(self, prefix, destiny):
        self.prefix = prefix
        self.destiny = destiny

    def tool_name(self):
        raise NotImplementedError()

    def url(self):
        raise NotImplementedError()

    def wrapper_url(self):
        raise NotImplementedError()

    def local_url(self):
        return self.destiny + "/" + self.tool_name()

    def exists(self):
        return os.path.exists(self.local_url())

class ESBMC(Tool):

    def url(self):
        return self.prefix + "/release/esbmc"

    def wrapper_url(self):
        return "https://raw.githubusercontent.com/sosy-lab/benchexec/master/benchexec/tools/esbmc.py"

    def tool_name(self):
        return "esbmc"


class TBFTestValidator(Tool):

    def url(self):
        return "https://gitlab.com/sosy-lab/test-comp/archives-2019/raw/master/2019/tbf-testsuite-validator.zip"

    def wrapper_url(self):
        return "https://raw.githubusercontent.com/sosy-lab/benchexec/master/benchexec/tools/tbf_testsuite_validator.py"

    def tool_name(self):
        return "tbf"

class FileToDownload:
    def __init__(self, origin, destiny):
        self.origin = origin
        self.destiny = destiny

    def download(self):
        r = requests.get(self.origin)
        with open(self.destiny, 'wb') as f:
            f.write(r.content)

    def get_origin(self):
        return self.origin

    def get_destiny(self):
        return self.destiny

class Benchmark:
    """Sets up the base environment"""

    def esbmc(self):
        return ESBMC(self.prefix, self.destiny)

    def tbf(self):
        return TBFTestValidator(self.prefix, self.destiny)

    def __init__(self, prefix, destiny):
        self.prefix = prefix
        self.destiny = destiny

    def benchmark_url(self):
        raise NotImplementedError()

    def benchmark_destiny(self):
        raise NotImplementedError()

    def prepare_folders(self):
        if(not os.path.exists(self.destiny)):
            logging.info("Creating directory structure")
            os.mkdir(self.destiny)
            os.mkdir(self.esbmc().local_url())
            assert self.esbmc().exists()
            copyfile(self.esbmc().url(),
                     self.esbmc().local_url() + "/esbmc")
            os.mkdir(self.tbf().local_url())
        else:
            logging.info("Found testcomp folder")

    def _download_file_if_needed(self, file_to_download: FileToDownload):
        if(not os.path.exists(file_to_download.get_destiny())):
            file_to_download.download()

    def _files_to_download(self):
        return [
            FileToDownload(self.esbmc().wrapper_url(), self.esbmc().local_url() + "/esbmc.py"),
            FileToDownload(self.tbf().url(), self.tbf().local_url() + "/tbf-testsuite-validator.zip"),
            FileToDownload(self.tbf().wrapper_url(), self.tbf().local_url() + "/tbf_testsuite_validator.py"),
            FileToDownload(self.benchmark_url(), self.destiny + "/benchmark.tar.gz")
        ]

    def prepare_files(self):
        logging.info("Downloading files")
        with multiprocessing.Pool(multiprocessing.cpu_count()) as p:
            p.map(self._download_file_if_needed, self._files_to_download())
        logging.info("Download finished")

    def extract_files(self):
        logging.info("Extracting files")
        if(not os.path.exists(self.destiny + "/tbf/tbf-testsuite-validator")):
           unpack_archive(self.destiny + "/tbf/tbf-testsuite-validator.zip",
                          self.destiny + "/tbf/")
        if(not os.path.exists(self.benchmark_destiny())):
            unpack_archive(self.destiny + "/benchmark.tar.gz",
                           self.destiny)

    def prepare(self):
        self.prepare_folders()
        self.prepare_files()
        self.extract_files()


        # --no-container \
        #   --output /home/esbmc/esbmc_src/testcomp/output.log\
        #   --limitCores 1 \
        #   --memorylimit "${1}GB" \
        #   --numOfThreads $2

class Runner():
    """Base class to run runxec"""

    def __init__(self):
        self.executor = RunExecutor()
        signal.signal(signal.SIGINT, self.stop_run)

    def stop_run(self):
        self.executor.stop()

    def _runexec_args(self):
        return []

    def _run(self, output):
        return self.executor.execute_run(
            args=self._runexec_args(),
            output_filename=output)

    # Should I spawn a process?
    def run(self, output):
        return self._run(output)

    def validate(self):
        raise NotImplementedError()

class TestCompRunner(Runner):
    """Runner with tbf-test validation"""
    pass

class SVCompRunner(Runner):
    """Runner with cpa witness validation"""
    pass
