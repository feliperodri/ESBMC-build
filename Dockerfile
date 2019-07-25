###################################
# NOTES
###################################

# This docker environment will add all scripts

###################################
# START
###################################
FROM rafaelsamenezes/esbmc-cmake:base

###################################
# Benchexec
###################################
USER root
RUN apt-get update \
        && wget https://github.com/sosy-lab/benchexec/releases/download/2.0/benchexec_2.0-1_all.deb \
        && apt install -y --install-recommends ./benchexec_*.deb \
        && rm benchexec_*.deb && adduser esbmc benchexec \
        && rm -rf /var/lib/apt/lists/*


###################################
# COPY
###################################
USER esbmc
WORKDIR /home/esbmc/
RUN mkdir /home/esbmc/scripts
COPY ./docker-scripts/* docker-scripts/
