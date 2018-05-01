FROM alpine:3.7

ENV MAPNIK_VERSION 3.0.20
ENV PYTHON_MAPNIK_VERSION v3.0.x

# maybe remove this after debugging is done
RUN apk --update add wget bash nano 

# 
RUN echo "@testing http://dl-cdn.alpinelinux.org/alpine/edge/testing" >> /etc/apk/repositories \
    && echo "@edge http://dl-cdn.alpinelinux.org/alpine/edge/main" >> /etc/apk/repositories

# set up build environment
RUN apk upgrade --update \
    && apk add --virtual .build-deps \
        autoconf \
        automake \
        build-base \
        curl \
        tar \
        git \
        zlib-dev \
        boost-dev \
        sqlite-dev \
        harfbuzz-dev \
        py3-setuptools@edge \
        python3-dev \
        cairo-dev \
        gdal-dev@testing \
        jpeg-dev \
        tiff-dev \

RUN mkdir build
WORKDIR /build
RUN curl -sSLO https://github.com/mapnik/mapnik/releases/download/v$MAPNIK_VERSION/mapnik-v$MAPNIK_VERSION.tar.bz2 \
    tar -xvjf mapnik-v$MAPNIK_VERSION.tar.bz2

RUN cd mapnik-v$MAPNIK_VERSION \
    && ./configure

RUN cd mapnik-v$MAPNIK_VERSION \
    && JOBS=4 make \
    && make install

RUN git clone --branch $PYTHON_MAPNIK_VERSION --single-branch --depth=1 https://github.com/mapnik/python-mapnik.git \
    && (cd python-mapnik \
        && python3 setup.py install)

#RUN curl -sSLO https://github.com/mapnik/python-mapnik/archive/v3.0.16.tar.gz \
#    && tar -zxvf v3.0.16.tar.gz