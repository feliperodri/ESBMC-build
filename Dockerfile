###################################
# NOTES
###################################

# This docker environment will add all scripts

###################################
# START
###################################
FROM rafaelsamenezes/esbmc-cmake:base

###################################
# COPY
###################################
WORKDIR /home/esbmc/
RUN mkdir /home/esbmc/scripts
COPY ./scripts/* scripts/
