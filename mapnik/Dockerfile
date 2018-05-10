FROM alpine:3.7

ENV MAPNIK_VERSION 3.0.20
ENV PYTHON_MAPNIK_VERSION v3.0.x

# add additional repositories
RUN echo "@testing http://dl-cdn.alpinelinux.org/alpine/edge/testing" >> /etc/apk/repositories \
    && echo "@edge http://dl-cdn.alpinelinux.org/alpine/edge/main" >> /etc/apk/repositories

# make sure we use the latest versions
RUN apk --update upgrade

# maybe remove this after debugging is done
RUN apk add wget bash nano 

# set up build environment
RUN apk add --virtual .build-deps \
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
        python3-dev \
        cairo-dev \
        py3-cairo \
        jpeg-dev \
        tiff-dev \
        icu \
        libwebp-dev \
        postgresql-dev

# additional packages
RUN apk add py-setuptools \
        py3-setuptools@edge \
        gdal-dev@testing \
        proj4-dev@testing

RUN mkdir build
WORKDIR /build
RUN curl -sSLO https://github.com/mapnik/mapnik/releases/download/v$MAPNIK_VERSION/mapnik-v$MAPNIK_VERSION.tar.bz2 \
    && tar -xjf mapnik-v$MAPNIK_VERSION.tar.bz2

RUN cd mapnik-v$MAPNIK_VERSION \
    && ./configure

RUN cd mapnik-v$MAPNIK_VERSION \
    && JOBS=4 make \
    && make install

#RUN git clone https://github.com/mapnik/python-mapnik.git
RUN git clone --branch $PYTHON_MAPNIK_VERSION --single-branch --depth=1 https://github.com/mapnik/python-mapnik.git

RUN cd python-mapnik \
    && python3 setup.py install

RUN cd python-mapnik \
    && python3 setup.py test || true

WORKDIR /

ENV USER=mapnik USER_ID=2000

# now creating user
RUN adduser -D -u ${USER_ID} ${USER}

COPY user-mapping.sh /
RUN  chmod u+x /user-mapping.sh
ENTRYPOINT ["/user-mapping.sh"]

# install python-bindings for mapnik from source
# RUN git clone --branch $PYTHON_MAPNIK_VERSION --single-branch --depth=1 https://github.com/mapnik/python-mapnik.git \
#     && (cd python-mapnik \
#         && python3 setup.py install \
#         && git submodule update --init \
#         && python3 setup.py test)
RUN rm -rf /var/cache/apk/*