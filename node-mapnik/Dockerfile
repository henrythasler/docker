FROM node:10.15-alpine

### Versions
ARG MAPNIK_VERSION="3.0.9"

### Download Locations
ARG MAPNIK_SOURCE="https://github.com/mapnik/mapnik/archive/v$MAPNIK_VERSION.tar.gz"

### update apk and existing packages
RUN apk upgrade --update \
#
### install dependencies
    ### build dependencies
    && apk add --virtual .build-deps \
        ### basic build packages              
        build-base \
        wget \
        bash \
        git \
        ### additional build packages    
        python3-dev \
        boost-dev \
        cairo-dev \
        libwebp-dev \
        harfbuzz-dev \
        icu-dev \
        jpeg-dev \
        tiff-dev \
        sqlite-dev \
    ### build packages from edge repo
    && apk add --virtual .build-deps-edge \
        --repository http://dl-cdn.alpinelinux.org/alpine/edge/main \
        openssl-dev \
        postgresql-dev \
    ### build packages from testing repo
    && apk add --virtual .build-deps-testing \
        --repository http://dl-cdn.alpinelinux.org/alpine/edge/testing \
        gdal-dev \
        proj4-dev \
    ### various runtime packages
    && apk add --virtual .run-deps \
        python3 \
        boost \
        boost-python3 \
        py3-cairo \
        libwebp \
        harfbuzz \
        icu \
    && apk add --virtual .run-deps-testing \
        --repository http://dl-cdn.alpinelinux.org/alpine/edge/testing \
        gdal \
        proj4
#
### Mapnik: Source download and extract
RUN wget $MAPNIK_SOURCE -O /tmp/mapnik-$MAPNIK_VERSION.tar.gz \
    && mkdir -p /usr/src \
    && tar xzf /tmp/mapnik-$MAPNIK_VERSION.tar.gz -C /usr/src
#
### Mapnik installation
RUN cd /usr/src/mapnik-${MAPNIK_VERSION} \
    && ./configure \
    && make -j $(nproc) \
    && make install
#
## clean up files
RUN apk del .build-deps \
    && rm -rf /tmp/* /var/cache/apk/* /usr/src/*

