FROM alpine:3.8

### Versions
ARG MAPNIK_VERSION="v3.0.21"
ARG PYTHON_MAPNIK_VERSION="v3.0.x"
ARG PYPROJ_VERSION="1.9.5.1rel"

### Download Locations
ARG MAPNIK_SOURCE="https://github.com/mapnik/mapnik/releases/download/$MAPNIK_VERSION/mapnik-$MAPNIK_VERSION.tar.bz2"
ARG PYTHON_MAPNIK_SOURCE="https://github.com/mapnik/python-mapnik.git"
ARG PYPROJ_SOURCE="https://github.com/jswhit/pyproj/archive/v$PYPROJ_VERSION.tar.gz"

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
        proj4 \
#
### Mapnik: Source download and extract
    && wget $MAPNIK_SOURCE -O /tmp/mapnik-$MAPNIK_VERSION.tar.bz2 \
    && mkdir -p /usr/src \
    && tar xjf /tmp/mapnik-$MAPNIK_VERSION.tar.bz2 -C /usr/src \
#    
### pyproj: Source download and extract
    && wget $PYPROJ_SOURCE -O /tmp/pyproj-$PYPROJ_VERSION.tar.gz \
    && mkdir -p /usr/src \
    && tar xzf /tmp/pyproj-$PYPROJ_VERSION.tar.gz -C /usr/src \
#
### Mapnik installation
    && cd /usr/src/mapnik-${MAPNIK_VERSION} \
    && ./configure \
    && make -j $(nproc) \
    && make install \
#    
### python-mapnik download + installation
    && cd /usr/src \
    && git clone --branch $PYTHON_MAPNIK_VERSION $PYTHON_MAPNIK_SOURCE python-mapnik \
    && ( cd python-mapnik \
        && python3 setup.py install) \
#        
# add additional python packages for various other purposes
### pyproj installation
    && cd /usr/src/pyproj-${PYPROJ_VERSION} \
    && python3 setup.py build \
    && python3 setup.py install \
#
## clean up files
    && apk del .build-deps \
    && rm -rf /tmp/* /var/cache/apk/* /usr/src/*

ENTRYPOINT ["sh"]