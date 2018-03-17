FROM alpine:3.7
ARG TZ='Europe/Berlin'
ENV TZ $TZ
ENV SS_LIBEV_VERSION 3.1.3
ENV KCP_VERSION 20180316
ENV OBFS_VERSION 0.0.5
ENV ARES_VERSION 1.14.0

RUN apk upgrade --update \
    && apk add bash tzdata libsodium nano \
    && apk add --virtual .build-deps \
        autoconf \
        automake \
        asciidoc \
        xmlto \
        build-base \
        curl \
        libev-dev \
        libtool \
        linux-headers \
        udns-dev \
        libsodium-dev \
        mbedtls-dev \
        pcre-dev \
        udns-dev \
        tar \
        git
RUN curl -sSLO https://c-ares.haxx.se/download/c-ares-$ARES_VERSION.tar.gz \
    && tar -zxf c-ares-$ARES_VERSION.tar.gz \
    && (cd c-ares-$ARES_VERSION \ 
        && ./configure \
        && make \
        && make install) \
    && curl -sSLO https://github.com/shadowsocks/shadowsocks-libev/releases/download/v$SS_LIBEV_VERSION/shadowsocks-libev-$SS_LIBEV_VERSION.tar.gz \
    && tar -zxf shadowsocks-libev-$SS_LIBEV_VERSION.tar.gz \
    && (cd shadowsocks-libev-$SS_LIBEV_VERSION \
        && ./configure --prefix=/usr --disable-documentation \
        && make install ) \
    && git clone --branch v$OBFS_VERSION https://github.com/shadowsocks/simple-obfs.git \
    && ( cd simple-obfs \
        && git submodule update --init --recursive \
        && ./autogen.sh && ./configure \
        && make && make install )
RUN curl -sSLO https://github.com/xtaci/kcptun/releases/download/v$KCP_VERSION/kcptun-linux-amd64-$KCP_VERSION.tar.gz \
    && tar -zxf kcptun-linux-amd64-$KCP_VERSION.tar.gz \
&& mv server_linux_amd64 /usr/bin/kcpserver \
&& mv client_linux_amd64 /usr/bin/kcpclient \
&& ln -sf /usr/share/zoneinfo/$TZ /etc/localtime \
    && echo $TZ > /etc/timezone \
&& runDeps="$( \
        scanelf --needed --nobanner /usr/bin/ss-* /usr/local/bin/obfs-* \
            | awk '{ gsub(/,/, "\nso:", $2); print "so:" $2 }' \
            | xargs -r apk info --installed \
            | sort -u \
        )" \
    && apk add --no-cache --virtual .run-deps $runDeps \
&& apk del .build-deps \
&& rm -rf kcptun-linux-amd64-$KCP_VERSION.tar.gz \
        shadowsocks-libev-$SS_LIBEV_VERSION.tar.gz \
shadowsocks-libev-$SS_LIBEV_VERSION \
        simple-obfs \
        /var/cache/apk/*

ADD entrypoint.sh /entrypoint.sh
ENTRYPOINT ["/entrypoint.sh"]
