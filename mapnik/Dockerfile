FROM alpine:3.7

ENV MAPNIK_VERSION 3.0.20
ENV PYTHON_MAPNIK_VERSION v3.0.x

# make sure we use the latest versions
RUN apk --update upgrade

# helper packages
RUN apk add --no-cache --virtual .fetch-deps \
        bash \
        wget \
        curl \
        tar \
        nano \
        git

# runtime dependencies
RUN apk add --no-cache --virtual .run-deps \
        icu \
        boost \
        boost-python3 \
        py3-cairo \
        libwebp \
        harfbuzz

RUN apk add --no-cache --virtual .run-deps-testing \
        --repository http://dl-cdn.alpinelinux.org/alpine/edge/testing \
        gdal@testing \
        proj4@testing

# build dependencies
RUN apk add --no-cache --virtual .build-deps \
        autoconf \
        automake \
        build-base \
        zlib-dev \
        boost-dev \
        sqlite-dev \
        harfbuzz-dev \
        python3-dev \
        cairo-dev \
        jpeg-dev \
        tiff-dev \
        libwebp-dev \
        postgresql-dev

RUN apk add --no-cache --virtual .build-deps-testing \
        --repository http://dl-cdn.alpinelinux.org/alpine/edge/testing \
        gdal-dev@testing \
        proj4-dev@testing

RUN apk add --no-cache --virtual .build-deps-edge \
        --repository http://dl-cdn.alpinelinux.org/alpine/edge/main \
        py3-setuptools

# prepare build environment
RUN set -ex \
    && mkdir -p /build
WORKDIR /build

# install mapnik from source
RUN curl -sSLO https://github.com/mapnik/mapnik/releases/download/v$MAPNIK_VERSION/mapnik-v$MAPNIK_VERSION.tar.bz2 \
    && tar -xjf mapnik-v$MAPNIK_VERSION.tar.bz2 \
    && (cd mapnik-v$MAPNIK_VERSION \
        && ./configure \
        && JOBS=4 make \
        && make install)

# install python-bindings for mapnik from source; ignore test result
RUN git clone --branch $PYTHON_MAPNIK_VERSION --single-branch --depth=1 https://github.com/mapnik/python-mapnik.git \
    && (cd python-mapnik \
        && python3 setup.py install \
        && python3 setup.py test || true)

# add additional python packages for various other purposes
RUN pip3 install pyproj

# clean up stuff
WORKDIR /
RUN rm -rf /build
RUN apk del .build-deps .build-deps-testing .build-deps-edge
RUN rm -rf /var/cache/apk/*

ENTRYPOINT ["bash"]