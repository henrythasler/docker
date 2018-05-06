FROM postgres:10-alpine
MAINTAINER Régis Belson <me@regisbelson.fr>

ENV POSTGIS_VERSION 2.4.3
ENV POSTGIS_SHA256 b9754c7b9cbc30190177ec34b570717b2b9b88ed271d18e3af68eca3632d1d95

ENV CGAL_VERSION 4.11.1
ENV SFCGAL_VERSION 1.3.5

RUN set -ex \
    \
    && apk add --no-cache --virtual .fetch-deps \
        ca-certificates \
        openssl \
        tar \
        xz \
    \
    && wget -O postgis.tar.gz "https://github.com/postgis/postgis/archive/$POSTGIS_VERSION.tar.gz" \
    && echo "$POSTGIS_SHA256 *postgis.tar.gz" | sha256sum -c - \
    && mkdir -p /usr/src/postgis \
    && tar \
        --extract \
        --file postgis.tar.gz \
        --directory /usr/src/postgis \
        --strip-components 1 \
    && rm postgis.tar.gz

RUN apk --update upgrade
RUN apk add --no-cache --virtual .build-deps \
        autoconf \
        automake \
        g++ \
        json-c-dev \
        libtool \
        libxml2-dev \
        make \
        perl \
        cmake \
        boost-dev \
        gmp-dev \
        mpfr-dev \
    \
    && apk add --no-cache --virtual .build-deps-testing \
        --repository http://dl-cdn.alpinelinux.org/alpine/edge/testing \
        gdal-dev \
        geos-dev \
        proj4-dev \
        protobuf-c-dev

# use 4.11.1 wget https://github.com/CGAL/cgal/releases/download/releases%2FCGAL-4.11.1/CGAL-4.11.1.tar.xz
RUN cd /usr/src \
    && wget -O cgal.tar.xz https://github.com/CGAL/cgal/releases/download/releases%2FCGAL-$CGAL_VERSION/CGAL-$CGAL_VERSION.tar.xz \
    && tar xf cgal.tar.xz \
    && cd CGAL-$CGAL_VERSION \
    && cmake . -Wno-dev \
    && make -j 4 \    
    && make install

#use 1.3.5 wget https://github.com/Oslandia/SFCGAL/archive/v1.3.5.tar.gz
RUN cd /usr/src \
    && wget -O sfcgal.tar.gz "https://github.com/Oslandia/SFCGAL/archive/v$SFCGAL_VERSION.tar.gz" \
    && tar xf sfcgal.tar.gz \
    && cd SFCGAL-$SFCGAL_VERSION \
    && cmake . -Wno-dev\
    && make -j 4 \    
    && make install

RUN cd /usr/src/postgis \
    && ./autogen.sh \
    && ./configure \
    && make -j 4\
    && make install
# RUN apk add --no-cache --virtual .postgis-rundeps \
#         json-c \
#         gmp \
#         mpfr3 \
#     && apk add --no-cache --virtual .postgis-rundeps-testing \
#         --repository http://dl-cdn.alpinelinux.org/alpine/edge/testing \
#         geos \
#         gdal \
#         proj4 \
#         protobuf-c \
#     && cd / \
#     && rm -rf /usr/src/postgis \
#     && apk del .fetch-deps .build-deps .build-deps-testing

RUN cp /usr/local/lib64/libSFCGAL.so* /lib

COPY ./initdb-postgis.sh /docker-entrypoint-initdb.d/postgis.sh
COPY ./update-postgis.sh /usr/local/bin

#  ldd /usr/local/lib/postgresql/postgis-2.4.so 
