FROM node:11-alpine

ENV NPM_CONFIG_PREFIX=/home/node/.npm-global
ENV PATH=$PATH:/home/node/.npm-global/bin

### update apk and existing packages
RUN apk upgrade --update &&\
#
### install dependencies
    ### build dependencies
    apk add --virtual .build-deps \
        ### basic build packages              
        bash \
        build-base \
        wget \
        curl \
        # git \
        python \
        make \
        g++ \
        ### additional build packages    
        # python3-dev \
        # boost-dev \
        # cairo-dev \
        # libwebp-dev \
        # harfbuzz-dev \
        # icu-dev \
        # jpeg-dev \
        # tiff-dev \
        # sqlite-dev \
        &&\
    apk add --virtual .build-deps-edge \
        --repository http://dl-cdn.alpinelinux.org/alpine/edge/main \
        boost-dev \
        icu-dev \
        &&\
    ### various runtime packages
    apk add --virtual .run-deps \
        libc6-compat \
        &&\
    ### from edge repo
    apk add --virtual .run-deps-edge \
        --repository http://dl-cdn.alpinelinux.org/alpine/edge/main \
        openssl \
        boost \
        boost-program_options \
        icu \
        &&\
    ### from testing repo
    apk add --virtual .run-deps-testing \
        --repository http://dl-cdn.alpinelinux.org/alpine/edge/testing \
        gdal \
        mapnik
    # &&\
#    
### install node-mapnik
    # npm install -g mapnik \
    # &&\
#
### clean up files
RUN    rm -rf /tmp/* /var/cache/apk/* /usr/src/*
