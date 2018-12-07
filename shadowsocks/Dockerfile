FROM alpine:3.8
ARG TZ='Europe/Berlin'
ENV TZ $TZ

# Version definitions
ARG ARES_VERSION="c-ares-1.15.0"
ARG SS_LIBEV_VERSION="3.2.3"
ARG KCPTUN_VERSION="20181114"
ARG OBFS_VERSION="0.0.5"

# path to download location
ARG ARES_SOURCE="https://c-ares.haxx.se/download/"
ARG SS_LIBEV_SOURCE="https://github.com/shadowsocks/shadowsocks-libev/releases/download/v"
ARG KCPTUN_SOURCE="https://github.com/xtaci/kcptun/releases/download/v"

# Checksums
ARG KCPTUN_SHA1="5d0cfb655e3ddd004f00e798d0aa802b22e88702"

### update apk and existing packages
RUN apk upgrade --update \
#
### install dependencies
    && apk add --virtual .build-deps \
        ### basic build packages              
        linux-headers \
        libtool \
        build-base \
        zlib-dev \
        wget \
        gnupg \
        autoconf \
        gcc \
        g++ \
        libc-dev \
        make \
        pkgconf \
        ca-certificates \  
        ### additional build packages    
        pcre-dev \
        git \
        mbedtls-dev \
        libsodium-dev \
        libev-dev \
        automake \
        asciidoc \
        xmlto \
    ### runtime packages        
    && apk add --virtual .run-deps \
        bash \
        libsodium \
        mbedtls \
        libev \
        pcre \
        musl \
#        
# Daniel Stenberg's public GPG key for c-ares (https://c-ares.haxx.se/). 
    && gpg --keyserver keys.internet-sicherheit.de --recv-key \
        27EDEAF22F3ABCEB50DB9A125CC908FDB71E12C2 \
#
### c-ares: Source download, verify and extract
    && wget $ARES_SOURCE$ARES_VERSION.tar.gz -O /tmp/$ARES_VERSION.tar.gz \
    && wget $ARES_SOURCE$ARES_VERSION.tar.gz.asc -O /tmp/$ARES_VERSION.tar.gz.asc \
    && gpg --verify /tmp/$ARES_VERSION.tar.gz.asc \
    && mkdir -p /usr/src \
    && tar xzf /tmp/$ARES_VERSION.tar.gz -C /usr/src \
#
### shadowsocks-libev: Source download and extract
    && wget $SS_LIBEV_SOURCE$SS_LIBEV_VERSION/shadowsocks-libev-$SS_LIBEV_VERSION.tar.gz -O /tmp/shadowsocks-libev-$SS_LIBEV_VERSION.tar.gz \
    && mkdir -p /usr/src \
    && tar xzf /tmp/shadowsocks-libev-$SS_LIBEV_VERSION.tar.gz -C /usr/src \
#
### kcptun: Download binaries, check SHA1SUM
    && wget $KCPTUN_SOURCE$KCPTUN_VERSION/kcptun-linux-amd64-$KCPTUN_VERSION.tar.gz -O /tmp/kcptun-linux-amd64-$KCPTUN_VERSION.tar.gz \
    && mkdir -p /usr/src \
    && echo "$KCPTUN_SHA1  /tmp/kcptun-linux-amd64-$KCPTUN_VERSION.tar.gz" | sha1sum -c - \
    && tar xzf /tmp/kcptun-linux-amd64-$KCPTUN_VERSION.tar.gz -C /usr/src \
    && mv /usr/src/server_linux_amd64 /usr/bin/kcpserver \
    && mv /usr/src/client_linux_amd64 /usr/bin/kcpclient \
#
### ARES installation
    && cd /usr/src/${ARES_VERSION} \
    && ./configure \
    && make -j $(getconf _NPROCESSORS_CONF) \
    && make install \
#
### shadowsocks-libev installation
    && cd /usr/src/shadowsocks-libev-${SS_LIBEV_VERSION} \
    && ./configure \
        --prefix=/usr \
        --disable-documentation \
    && make -j $(getconf _NPROCESSORS_CONF) \
    && make install \
#    
### simple-obfs installation
    && cd /usr/src \
    && git clone --branch v$OBFS_VERSION https://github.com/shadowsocks/simple-obfs.git \
    && ( cd simple-obfs \
        && git submodule update --init --recursive \
        && ./autogen.sh \
        && ./configure \
        && make -j $(getconf _NPROCESSORS_CONF) \
        && make install ) \
#
### Timezone settings
    && ln -sf /usr/share/zoneinfo/$TZ /etc/localtime \
    && echo $TZ > /etc/timezone \
#
### clean up files
    && apk del .build-deps \
    && rm -rf /tmp/* /var/cache/apk/* /usr/src/* \
#
# FIXME: Check if/how that works
### Scan executables for additional dependencies; install if needed (probably not)
    && runDeps="$( \
        scanelf --needed --nobanner /usr/bin/ss-* /usr/local/bin/obfs-* \
        | awk '{ gsub(/,/, "\nso:", $2); print "so:" $2 }' \
        | xargs -r apk info --installed \
        | sort -u \
        )" \
    && echo "Missing dependencies: $runDeps" \
    && apk add --no-cache --virtual .run-deps $runDeps 

COPY entrypoint.sh /entrypoint.sh
ENTRYPOINT ["/entrypoint.sh"]
